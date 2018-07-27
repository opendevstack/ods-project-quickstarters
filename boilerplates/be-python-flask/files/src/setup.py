from setuptools import setup, find_packages


setup (
  name                 = "ods-python-flask",
  version              = "0.1.0",
  description          = "OpenDevStack Python Flask service template",
  packages             = find_packages(),
  include_package_data = True,
  install_requires     = ["flask"],
  extras_require       = {
                            "test": [
                              "colorama",
                              "coverage",
                              "nose2",
                              "pinocchio"
                            ]
                         })
