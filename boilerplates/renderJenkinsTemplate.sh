#!/bin/bash

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
    key="$1"

    case $key in
        -t|--target)
            target="$2"
            shift # past argument
            ;;
        -u|--url)
            git_url_http="$2"
            shift # past argument
            ;;
       -p|--project-id)
            project_id="$2"
            shift # past argument
            ;;
        -c|--component-id)
            component_id="$2"
            shift # past argument
            ;;
        -t|--component-type)
            component_type="$2"
            shift # past argument
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
done


# change to directory of this script
cd $(dirname "$0")
# replace placeholders
echo "target: $target, url: $git_url_http, project-id: $project_id, component-id: $component_id, component-type: $component_type"
sed 's|@project_id@|'$project_id'|g; s|@component_id@|'$component_id'|g; s|@component_type@|'$component_type'|g; s|@git_url_http@|'$git_url_http'|g' ./$component_type/Jenkinsfile > $target
