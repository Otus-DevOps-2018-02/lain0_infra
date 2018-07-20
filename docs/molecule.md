# Molecule
install molecule , it doesn't support python3.5

```
sudo apt install python3.6-dev
pip install virtualenv
```
python3 -m virtualenv env
```
pip install --user pipenv
virtualenv --python=python3.6 ~/py3.6
source ~/py3.6/bin/activate
```
now we can pip install molecule
### Molecule init vs configured vagrant
molecule init scenario --scenario-name default -r rolename -d vagrant
### tasks of molecule are in rolename/molecule/default/tests/test_default.py
### create vm vs molecule:
`molecule create`
### molecule vm list:
`molecule list`
### login to molecule instance:
`molecule login -h instance`
### generate molecule role:
`molecule init`
