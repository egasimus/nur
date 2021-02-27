#!/usr/bin/env python
import distutils
distutils.core.setup(
    name='GST',
    version='1.0',
    install_requires=['absl-py==0.11.0', 'aiohttp']
)
