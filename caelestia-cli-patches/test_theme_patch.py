import importlib.util
import os
import subprocess
import sys
import tempfile
import types
import unittest
from pathlib import Path


REPO_DIR = Path(__file__).resolve().parent


class ThemePatchTests(unittest.TestCase):
    def load_patch_modules(self, workspace: Path):
        config_dir = workspace / "config"
        data_dir = workspace / "data"
        templates_dir = workspace / "templates"
        theme_dir = workspace / "theme"
        c_state_dir = workspace / "state"
        user_config_path = workspace / "user-config.json"
        user_templates_dir = workspace / "user-templates"

        for directory in [
            config_dir,
            data_dir,
            templates_dir,
            theme_dir,
            c_state_dir,
            user_templates_dir,
        ]:
            directory.mkdir(parents=True, exist_ok=True)

        package = types.ModuleType("caelestia")
        package.__path__ = []
        utils_pkg = types.ModuleType("caelestia.utils")
        utils_pkg.__path__ = []
        logging_mod = types.ModuleType("caelestia.utils.logging")
        logging_mod.log_exception = lambda func: func
        paths_mod = types.ModuleType("caelestia.utils.paths")
        paths_mod.c_state_dir = c_state_dir
        paths_mod.config_dir = config_dir
        paths_mod.data_dir = data_dir
        paths_mod.templates_dir = templates_dir
        paths_mod.theme_dir = theme_dir
        paths_mod.user_config_path = user_config_path
        paths_mod.user_templates_dir = user_templates_dir

        sys.modules["caelestia"] = package
        sys.modules["caelestia.utils"] = utils_pkg
        sys.modules["caelestia.utils.logging"] = logging_mod
        sys.modules["caelestia.utils.paths"] = paths_mod

        colour_spec = importlib.util.spec_from_file_location(
            "caelestia.utils.colour", REPO_DIR / "colour.py"
        )
        colour_module = importlib.util.module_from_spec(colour_spec)
        sys.modules["caelestia.utils.colour"] = colour_module
        colour_spec.loader.exec_module(colour_module)

        theme_spec = importlib.util.spec_from_file_location(
            "caelestia.utils.theme", REPO_DIR / "theme.py"
        )
        theme_module = importlib.util.module_from_spec(theme_spec)
        sys.modules["caelestia.utils.theme"] = theme_module
        theme_spec.loader.exec_module(theme_module)

        return theme_module, config_dir, templates_dir

    def test_apply_qt_preserves_qtengine_and_qtct_outputs(self):
        with tempfile.TemporaryDirectory() as tmp_dir:
            workspace = Path(tmp_dir)
            theme_module, config_dir, templates_dir = self.load_patch_modules(workspace)

            (templates_dir / "qtdark.colors").write_text("accent={{ $primary }}\n")
            (templates_dir / "qtengine.json").write_text(
                '{"iconTheme":"Papirus-{{ $mode }}"}\n'
            )
            (templates_dir / "qtct.conf").write_text(
                "[Appearance]\ncolor_scheme_path={{ $config }}/colors/caelestia.conf\nicon_theme=Breeze {{ $mode }}\n"
            )
            (templates_dir / "qtdark.conf").write_text(
                "[ColorScheme]\nactive_colors={{ primary.argb }}\n"
            )

            colours = {"primary": "112233"}
            theme_module.apply_qt(colours, "dark")

            self.assertEqual(
                (config_dir / "qtengine/caelestia.colors").read_text(),
                "accent=#112233\n",
            )
            self.assertIn(
                "Papirus-Dark",
                (config_dir / "qtengine/config.json").read_text(),
            )
            self.assertEqual(
                (config_dir / "qt5ct/colors/caelestia.conf").read_text(),
                "[ColorScheme]\nactive_colors=#ff112233\n",
            )
            self.assertIn(
                "Breeze Dark",
                (config_dir / "qt5ct/qt5ct.conf").read_text(),
            )

    def test_apply_and_revert_scripts_handle_missing_qtct_backup(self):
        with tempfile.TemporaryDirectory() as tmp_dir:
            workspace = Path(tmp_dir)
            caelestia_dir = workspace / "caelestia"
            templates_dir = caelestia_dir / "data/templates"
            utils_dir = caelestia_dir / "utils"
            templates_dir.mkdir(parents=True)
            utils_dir.mkdir(parents=True)

            original_colour = "original colour\n"
            original_theme = "original theme\n"
            original_qtdark = "original dark\n"
            original_qtlight = "original light\n"

            (utils_dir / "colour.py").write_text(original_colour)
            (utils_dir / "theme.py").write_text(original_theme)
            (templates_dir / "qtdark.conf").write_text(original_qtdark)
            (templates_dir / "qtlight.conf").write_text(original_qtlight)

            env = os.environ.copy()
            env["CAELESTIA_DIR"] = str(caelestia_dir)

            subprocess.run(
                ["bash", str(REPO_DIR / "apply-patches.sh")],
                check=True,
                env=env,
                cwd=REPO_DIR,
            )

            self.assertTrue((utils_dir / "colour.py.bak").exists())
            self.assertTrue((utils_dir / "theme.py.bak").exists())
            self.assertFalse((templates_dir / "qtct.conf.bak").exists())
            self.assertEqual((utils_dir / "colour.py.bak").read_text(), original_colour)
            self.assertEqual((utils_dir / "theme.py.bak").read_text(), original_theme)
            self.assertEqual(
                (templates_dir / "qtdark.conf.bak").read_text(), original_qtdark
            )
            self.assertEqual(
                (templates_dir / "qtlight.conf.bak").read_text(), original_qtlight
            )
            self.assertTrue((templates_dir / "qtct.conf").exists())

            subprocess.run(
                ["bash", str(REPO_DIR / "revert-patches.sh")],
                check=True,
                env=env,
                cwd=REPO_DIR,
            )

            self.assertEqual((utils_dir / "colour.py").read_text(), original_colour)
            self.assertEqual((utils_dir / "theme.py").read_text(), original_theme)
            self.assertEqual(
                (templates_dir / "qtdark.conf").read_text(), original_qtdark
            )
            self.assertEqual(
                (templates_dir / "qtlight.conf").read_text(), original_qtlight
            )
            self.assertFalse((templates_dir / "qtct.conf").exists())


if __name__ == "__main__":
    unittest.main()
