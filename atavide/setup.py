import os
from setuptools import setup

def get_version():
    with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'atavide', 'atavide.VERSION')) as f:
        return f.readline().strip()

CLASSIFIERS = [
    "Environment :: Console",
    "Environment :: MacOS X",
    "Intended Audience :: Science/Research",
    "License :: OSI Approved :: MIT license",
    "Natural Language :: English",
    "Operating System :: POSIX :: Linux",
    "Operating System :: MacOS :: MacOS X",
    "Programming Language :: Python :: 3.7",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Topic :: Scientific/Engineering :: Bio-Informatics",
]

setup(
 name='atavide',
 description="snaketool",
 version=get_version(),
 author="Bhavya Papudeshi",
 author_email="nala0006@flinders.edu.au",
 py_modules=['atavide'],
 install_requires=["snakemake==7.14.0",
                   "pyyaml==6.0",
                   "Click==8.1.3"],
 entry_points={
  'console_scripts': [
    'atavide=atavide.__main__:main'
  ]},
 include_package_data=True,
)
