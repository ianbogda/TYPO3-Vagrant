# About TYPO3 Vagrant/Travis cookbooks

## Based on Travis cookbooks
Travis cookbooks are collections of Chef cookbooks for setting up

 * VMs for running tests (CI environment)
 * Travis worker machine (host OS)
 * Anything else we may need to set up (for example, messaging broker nodes)


### Other VM infrastructure projects

Travis cookbooks are now part of a larger project that travis-ci.org developers use to create VM images for our CI environment.
It is called [travis-boxes](https://github.com/travis-ci/travis-boxes).


## Requirements

You need to have Virtualbox 4.1.+ installed and Vagrant.

# Getting started with Vagrant