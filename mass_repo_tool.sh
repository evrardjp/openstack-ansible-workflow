#!/usr/bin/env bash

# This is a simple script to do bulk operations on all projects we support
# Operation:
#   The script clones project config from OpenStack infra then parses the gerrit
#   projects for all of our known projects. Known projects are determined by the
#   name using "openstack/openstack-ansible". Once all projects are discovered a
#   string is built with the "<NAME>|<URL>" and printed. The script then clones
#   all projects into the workspace and runs the ``bulk_function``. When complete
#   the script commits the changes using the message provided and submits
#   everything for review.


###############################################################
#
# Create your bulk Message here
# Note this should be built in correct git commit message form.
#
###############################################################
MESSAGE="
Bulk job commit message

This is a commit message from your friendly neighborhood bulk job runner
Please replace this message with something more appropriate for the thing
you are doing.

"


###############################################################
#
# Add your job here. This can be anything you want or need to
# do within a given repository that we support
#
###############################################################
function bulk_function {
#    git stash clear
#    git stash -q
    git checkout master -q
    git pull --all
    git checkout -b mitaka origin/stable/mitaka -q
}


WORKSPACE=~/openstack/$1

mkdir -p "${WORKSPACE}"
rm -rf "${WORKSPACE}/project-config/"
git clone https://github.com/openstack-infra/project-config "${WORKSPACE}/project-config"

pushd "${WORKSPACE}/project-config"

PROJECTS=$(python <<EOR
import yaml
with open('gerrit/projects.yaml') as f:
    projects = yaml.load(f.read())
for project in projects:
    if project['project'].startswith('openstack/openstack-ansible'):
        project_name = project['project'].split('/')[-1].split('openstack-ansible-')[-1]
        project_github = 'https://github.com/%s' % project['project']
        print('%s|%s' % (project_name, project_github))
EOR
)

for project in ${PROJECTS}; do
    git clone -q ${project#*'|'} "${WORKSPACE}/${project%%'|'*}"
    pushd "${WORKSPACE}/${project%%'|'*}"

    bulk_function

    popd
done

popd
