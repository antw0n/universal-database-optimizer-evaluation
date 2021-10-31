#!/bin/env python3
import argparse
import fnmatch
import os
import re
import sys

import yaml
from jinja2 import Environment, FileSystemLoader


def parse_options(argv):
    script_dir = os.path.dirname(os.path.realpath(__file__))
    parser = argparse.ArgumentParser()
    parser.add_argument("-e", "--explain", help="render explain experiments", action="store_true")
    parser.add_argument("-i", "--index", help="render index experiments", action="store_true")
    parser.add_argument("-t", "--templates_dir", help="directory holding tpch query templates", default="{}/../templates".format(script_dir))
    parser.add_argument("-f", "--vars_file", help="file containing jinja2 variables")
    parser.add_argument("-o", "--output_dir", help="directory to store rendered experiments", default="{}/../experiments".format(script_dir))
    args = parser.parse_args(argv)
    return args


def get_level(path):
    regex = re.compile(r"/")
    level = len(regex.findall(path))
    return level


def get_dirs(templates_dir):
    paths = [templates_dir]
    for root, dirs, files in os.walk(templates_dir):
        for dname in dirs:
            paths.append(os.path.join(root, dname))
    return paths


def get_variables(vname, levels, level):
    variables = {}
    for l in range(0, level):
        try:
            variables.update(levels[l])
        except KeyError as e:
            continue
    try:
        with open(vname) as vars_file:
            variables.update(yaml.safe_load(vars_file))
    except OSError as e:
        pass
    return variables


def main(argv):
    args = parse_options(argv)
    os.makedirs(args.output_dir, exist_ok=True)

    levels = {}
    variables = {}

    if args.vars_file is not None:
        base_level = 0
        variables = get_variables(args.vars_file, levels, base_level)
        levels[base_level] = variables

    for dname in get_dirs(args.templates_dir):
        level = get_level(dname)
        variables = get_variables("{}/vars.yml".format(dname), levels, level)
        levels[level] = variables
        j2env = Environment(loader=FileSystemLoader(dname), trim_blocks=True)
        templates = os.listdir(dname)
        for t in templates:
            if fnmatch.fnmatch(t, "*.j2"):
                template = j2env.get_template(t)
                sub_dname = dname.removeprefix(args.templates_dir)
                if sub_dname:
                    os.makedirs("{}/{}".format(args.output_dir, sub_dname), exist_ok=True)
                query_filepath = '/'.join(filter(None, [args.output_dir, sub_dname, t[:-3]]))
                with open(query_filepath, "w") as f:
                    query_content = template.render(variables=variables, explain=args.explain, index=args.index)
                    f.write(query_content)


if __name__ == "__main__":
    main(sys.argv[1:])
