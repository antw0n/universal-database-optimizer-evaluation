# Description

This repository contains amended version of the implementation used for the experiments described
on the paper: "Experimental Comparison of Relational and NoSQL Systems: the Case of Decision Support"

The sole purpose of this amendment is to evaluate the [universal database optimizer (UDO)](https://github.com/antw0n/universal-database-optimizer).

# Quick start

**Execution**  

Per default the experiment executor will run all the experiments and forces the given timeout. 
The `basic` experiments run once, whereas the experiments that produce explain statements (`explain`) will be executed five times.
Average execution time of all the executions is added to `results.csv`.
Optimization experiment (`optim`) is executed as well and therefore `_input` should be provided. 

**Steps**  

1. Provide required configurations
2. Execute `build and load all` and `execute experiments (all)`

On failure: add missing configuration.

# Run Configuration

The project supports `Intellij run configurations`:

- main  
`build and load all`: build all experiments and load all datasets  
`execute experiments (all)`: run experiment executor  

- load  
`load_all`: load all datasets  
`load dataset`: load default dataset  
`load dataset (mongo_1c)`: load mongo_1c dataset  
`load dataset (mongo_2c)`: load mongo_2c dataset  
`load dataset (mongo_3c)`: load mongo_3c dataset  
`load dataset (postgres)`: load postgres dataset  

- build and load  
`build and load dataset`: build and load mongo_1c dataset  
`build and load dataset (mongo_1c)`: build and load mongo_1c dataset  
`build and load dataset (mongo_2c)`: build and load mongo_2c dataset  
`build and load dataset (mongo_3c)`: build and load mongo_3c dataset  

- generate  
`generate_basic_experiments`: generate experiments that output results  
`generate_indexed_experiments`: generate indexed experiments that output results  
`generate_explained_experiments`: generate experiments that output explain statements  
`generate_creation_statements`: generate basic experiments  
`generate_explained_and_indexed_experiments`: generate indexed experiments that output explain statements  

- run  
`run experiment (1)`: run single experiment defined by identifier, e.g. 1  
`run experiment (all)`: run all experiments  
`run_experiment (all) (force_timeout)`: run all experiments with forced timeout  

# Directory Structure

```
.
├── bin
│   └── crjoin
├── config
├── _input
│   ├── s1
│   ├── s2
│   └── s3
├── input
├── lib
├── output
│   ├── creation
│   ├── dataset
│   ├── experiments
│   ├── queries (temp)
│   └── results (temp)
├── templates
└── tpch_tools
```

## bin
Contains the scripts used to create and run the experiments. Queries are rendered using
the `create_queries.py` script (use `-h` option for help) and then run using the
`run_experiment.sh` script (use `-h` option for help). The `crjoin` sub-folder contains
the `C++` source code of a program we designed to transform the TPCH tables: customer,
orders, and lineitem, produced by DBGEN to MongoDB's extended json format. The program
was originally built using GCCv8.3.0 and can be compiled using `make`.

**NOTE:** It is assumed MongoDB's access control is disabled.
The scripts only work (as they are) on a MongoDB deployment that does not enforce
authentication.

## config
Contains the database and dataset configuration files. Sample configurations are provided for:
- Experiment configuration: ```example_experiment_config```
- MongoDB configuration:  ```example_mongoconfig```
- PostgreSQL configuration: ```example_postgresconfig```

## _input and input
Storage for the optimized configuration suggested by UDO. Substructure according to the query set (`s1`,`s2`,`s3`) and configuration files:
- `add_ext_idx_config.js` for index configuration
- `add_ext_db_config.js` for database configuration

`_input` is a configuration storage folder. The configuration can be placed here and it won't be considered during the experimentation.
`input` is active configuration folder. A suggested configuration can be activated by moving it in this folder.

## lib
Contains all the utilities:
- `config.sh`: configuration utilities
- `generate_data.sh`: data generation utilities
- `import_data.sh`: data import utilities
- `utils.sh`: common utilities

## templates

Contains the `jinja2` templates of all PSQL and MongoDB **queries** and scripts involved in the
creation of the schemas used during experimentation. The `vars.yml` file
has all variables required to render such templates written with the default values used for
experiments.

The sub-directory `templates` is divided in creation scripts (`creation`) and experiment specific queries (`experiments`):  
- `creation`: structured per database (`mongo`|`psql`)  
- `experiments`: follows the form `<experiment>/<database>/<query set>/`
```
├── templates
│   ├── creation
│   │   ├── mongo
│   │   └── psql
│   └── experiments
│       ├── [ tpch_experiment | point_queries_experiment ]
│           ├── mongo
│           │   ├── s1
│           │   ├── s2
│           │   └── s3
│           └── psql
```

## output

Contains the creation scripts, datasets, and results for each experiment on different scale factors. 

**Creation**  

Contains all creation scripts.  
The scripts for Postgres are mandatory. 
The scripts for MongoDB are not required.  

**Dataset**  

Datasets according to the paper: "Experimental Comparison of Relational and NoSQL Systems: the Case of Decision Support"

**Experiments**  

The sub-directory `experiments` follows the form `<indexing mode>/<execution mode>/<input/output>/<experiment>/`:
```
.
├── indexing mode [ index | no-index | optim ]
│   ├── execution mode [ basic | explain ]
│   │   ├── input/output [ queries | results ]
│   │   │   ├── experiment [ point_queries_experiment | tpch_experiment ]
│   │   │       ├── mongo
│   │   │       │   ├── s1
│   │   │       │   ├── s2
│   │   │       │   └── s3
│   │   │       └── psql
```
---    
*Indexing mode* 
- ```index```: contains experiments executed with indexing  
- ```no-index```: contains experiments executed without indexing  
- ```optim```:  contains experiments executed with indexing optimized by UDO  

*Timeout*   
- ```timeout```: interrupts operation executed in ```mongo shell```
- ```forced timeout```: interrupts ```mongo shell```

*Execution mode*   
- ```explain```: The file `results.csv` in `<explain/results>` contains the average running time or timeout note for each query. The results of SQL ```expaline``` can be found in the `<query>.explain` files.   
- ```basic```: The file `results.csv` in `<basic/results>` contains the value `-nan` for successful execution or timeout note if execution takes too long. The query results are stored in the `<query>.out` files.   

*Experiment*  

Output of the experiments according to the paper: "Experimental Comparison of Relational and NoSQL Systems: the Case of Decision Support"
Only two experiment types are considered:
- point_queries_experiment
- tpch_experiment

**Queries**  

Temporary folder  created during the execution of a specific experiment according to the paper: "Experimental Comparison of Relational and NoSQL Systems: the Case of Decision Support".  
The folder contains all the queries for that specific experiment.

**Results**  

Temporary folder created during the execution of a specific experiment according to the paper: "Experimental Comparison of Relational and NoSQL Systems: the Case of Decision Support".
The folder contains all the results of that specific experiment.

## tpch_tools

Contains all TPC-H benchmark related tools and data.

# NOTES

## Query Generation

Queries can be rendered using the `create_queries.py` script under `./bin`. For
instance, to generate all queries from the `TPCH` experiment one could
execute::

  ./bin/create_queries.py -t ./templates/tpch_experiment -o /path/to/output/dir

## TPC-H dataset generation

The first step is to render the scripts inside the `templates/creation` folder. To do
so you can use the `create_queries.py` script. An example is shown below.::

  ./bin/create_queries.py -t ./templates/creation -o /path/to/output/dir

Then, follow the instructions for each database below.

## PostgreSQL
1. Execute `./dbgen -s <scale factor>` inside `/path/to/TPC\_H/dbgen/`.
2. Remove the extra `|` at the end of each line from each `.tbl` file produced 
   in the previous step. For example, as shown below.::

     for i in`ls *.tbl`; do sed -i's/|$//'$i; done

3. Import the data into PostgreSQL using the rendered `create_rdb.sql` script
   from the `creation` templates.

## MongoDB
1. Sort order by `custkey`::
    ```
    # sort stores temporary files in /tmp by default. If the
    # data is considerably big, one may need to use the -T option.
    sort -k 2 -n -t '|' orders.tbl > orders_sorted.csv
    ```

2. Sort lineitems by orderkey taken into consideration the new order produced from the
   previous step::
    ```
    awk -F'|' 'NR==FNR{o[$1]=FNR; next} {print o[$1] "|" $0}' \
    <(awk -F'|' '{print $1}' orders_sorted.csv | uniq) \
    lineitem.tbl | sort -t '|' -nk1 | cut -d'|' -f2- > \
    lineitem_sorted.csv
    ```
3. Compile the program under `./bin/crjoin/crjoin`.
4. Manually create the desired schemas using the program from the previous step and import
   the produced json file/s to MongoDB. You can use the rendered `build.sh` script 
   (use the `-h` option for help) from the `creation` templates as a guide.
