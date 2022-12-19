# hakkoda_edw Data Vault 2.0

## Project Overview
This dbt project is a sample project meant to provide an understanding of how to use Snowflake, dbt (including dbtvault), Github, and Hakkoda's Data Vault custom implementation Recipe and Accelerators.

### Pre-project Checklist
Each team member should have the following access:
- [ ] Snowflake account (https://ht48847.canada-central.azure.snowflakecomputing.com/)
- [ ] Member of dbt Cloud Hakkoda EDW Data Vault Project
- [ ] Write Access to GitHub Hakkoda EDW Data Vault Project repo
- [ ] Access to Snowflake HAKKODA_EDW database(s) including DEV, QA, and PROD environments
- [ ] Snowflake Role HAKKODA_EDW_ROLE

### Solution Architecture
The following high-level diagram describes how data will be ingested from the sample source sources, modeled in a Data Vault 2.0 Raw Vault, Business Vault and Information Mart for downstream analytics. The diagram is available as a template in Miro [here](https://miro.com/app/board/uXjVP8uiR7s=/?share_link_id=809372791811) and show below:

![image](https://drive.google.com/uc?export=view&id=1KCcAW0A8PZBjacwoOMJeYu4RFqAU-ue3)

### Project Lifecycle
The following steps are document the lifecycle of a data engineering pipeline on our project from environment setup, ingesting data into Snowflake, transforming it and finally serving it up for analytics and other downstream uses. 

#### 1. Environment Setup & Configuration
Setup the Snowflake, Azure & dbt environments for the project. This will include configuring Azure & Snowflake objects to load sample data via Snowpipe to Snowflake, configuring dbt Cloud for the development team and deployment, and GitHub to create Data Warehouse releases. 

#### 2. Design Target Data Model
The following target data model is to be built via dbt Cloud. Use the naming conventions in the appendix for the Information Mart [Model Layers](#model-layers). Prototype views should be written for each target table for use in unit testing to check row counts and column values (See [Unit Testing](#unit-testing) in the appendix):

![image](https://drive.google.com/uc?export=view&id=17BpnvjbKltSnqMRaVSChKhbz94vo-jUc)

#### 3. Design Data Pipelines
The design of the dbt-based Data Pipelines are documented in the appendix below. This includes relevant packages, macros, models and testing. See [Model Organization](#model-organization) for more information. 

#### 4. Build Data Pipelines
The following steps should be followed for each step of the development process for building a dbt-based data pipeline and following the [Branching Strategy](#branching-strategy) outlined in the appendix:

##### a. Ingest data to Snowflake 
Ingest data into Snowflake via macros in the [dbt-external-tables package](https://github.com/dbt-labs/dbt-external-tables/tree/0.8.2/) package. This will create a pipe using Snowflake objects Storage Integration, Notification Integration, File Format and Stage. Perform unit testing and include screen shots in your pull request to show how file(s) were initially loaded and then subsequent files were loaded during a second load.

##### b. Build Raw & Hash Stage dbt model(s)
Raw & Hash Stage data models will be created for each source table/file. Use the naming convention below in the [Model Layers](#model-layers) section of the appendix. Raw models should include testing for source freshness and descriptions for the purpose of each table. 

##### c. Build Raw Vault dbt model(s)
Raw Vault data models will be created to load the data from Raw & Hash Stage data models into a Raw Vault using Data Vault 2.0 standards. The models will make use of the macros in the [dbtvault package](https://dbtvault.readthedocs.io/en/latest/). Use the naming convention below in the [Model Layers](#model-layers) section of the appendix. Raw Vault models should include testing for uniqueness, not null fields and descriptions for the purpose of each model and referential integrity (where applicable). 

##### d. Build Business Vault & Information Mart dbt model(s)
Business Vault & Information Mart data models will be created to prepare data for consumption by analysts and other downstream uses. Use the naming convention below in the [Model Layers](#model-layers) section of the appendix. Business Vault models will be created on an optional basis to improve performance or cleanse/standardize data for downstream use. Information Mart models should include testing for uniqueness, referential integrity (where applicable), not null fields and descriptions for the purpose of each model and column. 

##### e. Build dbt job(s)
dbt Jobs will be created within the dbt Cloud UI to orchestrate Data Warehouse loads on a regular interval. The job(s) will be composed of a series of commands (i.e. `dbt run`, `dbt test`, and `dbt run-operation`) to load, test, and perform maintenance operations.

#### 5. Deploy Data Pipelines
The development lifecycle of the Data Warehouse will include 3 environments; Development (HAKKODA_EDW_DEV), Quality Assurance (HAKKODA_EDW_QA) and Production (HAKKODA_EDW). Once development has been completed on a data pipeline (including unit testing & applying tests/documentation) the developer will create a [pull request](#pull-request-template) using the standards defined in the appendix and then the new feature or fix will follow the steps listed [here](#deployment-workflow) before making it into Production where it will be consumed with the analysts.

## Appendix

### dbt Packages  
Our dbt project will make use of the following dbt packages to expedite development and enforce consistency:

| Category | Description                                             |
|----------|---------------------------------------------------------|
| [dbtvault](https://github.com/Datavault-UK/dbtvault)      | Contains macros to build a Data Vault 2.0 Data Warehouse Raw Vault & Business Vault.       |
| [dbt-external-tables](https://github.com/dbt-labs/dbt-external-tables)      | Contains macros to ingest data from cloud storage into Snowflake via external tables and pipes.        |
| [dbt-audit-helper](https://github.com/dbt-labs/dbt-audit-helper)  | Contains macros for audting your dbt models for unit testing purposes.        |

#### How to add a package to your dbt project?
1. Add a `packages.yml` file to your dbt project. This should be at the same level as your `dbt_project.yml` file. Specify the package(s) you wish to add using one of the supported syntaxes, for example:
  ```yml
  packages.yml
  packages:
    - package: dbt-labs/snowplow
      version: 0.7.0

    - git: "https://github.com/dbt-labs/dbt-utils.git"
      revision: 0.9.2

    - local: /opt/dbt/redshift
  ```  

2. Run `dbt deps` to install the package(s). Packages get installed in the dbt_packages directory – by default this directory is ignored by git, to avoid duplicating the source code for the package.

### Model Organization  
Our models (typically) fit into the following categories:

| Category    | Description                                                  |
|-------------|--------------------------------------------------------------|
| raw_stage   | Contains models from sources organized by source system |
| hash_stage  | Contains models from refs of raw_stage with additional hashes and metadata columns added |
| raw_vault   | Contains models generated by dbtvault macros organized by type of data vault object (i.e. hubs, links, etc) |
| biz_vault   | Contains models from refs of raw_vault for performance or reusability (i.e. point-in-time table, computed satellites) |
| info_mart   | Contains models from raw or biz_vault transformed into dimension model or wide tables for use by analysts |
| source_mart | Contains models from raw_vault transformed to represent the original structure from the source system table or file |
| unit_test   | Contains models from refs used to unit test a model and ensure it contains the correct data before creating a PR |
  
Things to note:
- There are different types of models
that typically exist in each of the above categories.  
See [Model Layers](#model-layers) for more information. 

- Read [How we structure our dbtvault projects](https://dbtvault.readthedocs.io/en/latest/worked_example/we_staging/) for an example and more details around organization.

### Model Layers
- Only models in `raw_stage` should select from [sources](https://docs.getdbt.com/docs/building-a-dbt-project/using-sources)
- Models not within the `raw_stage` folder should select from [refs](https://docs.getdbt.com/reference/dbt-jinja-functions/ref).
- The following are the DAG stages that we tend to utilize:
  <details>

  <summary>Common</summary>

    | dag_stage | Typically found in      | description                                                        |
    |-----------|-------------------------|--------------------------------------------------------------------|
    | seed_     | /seeds                  | Indicates a data set created from `dbt seed`. |
    | stage_    | /models/raw_stage       | Indicates a data set that is being staged from a source. This layer will also include logic to perform initial load or incremental (if necessary). |
    | primed_   | /models/hash_stage      | Indicates a logical step towards preparing a stage data set for use in the configuring the dbtvault macros. Typically includes hash keys and metadata columns. |
    | hub_      | /models/raw_vault/hubs  | Indicates a Data Vault 2.0 hub data set created from the dbtvault hub macro. |
    | hsat_     | /models/raw_vault/sats  | Indicates a Data Vault 2.0 hub satellite data set created from the dbtvault satellite macro. |
    | lnk_      | /models/raw_vault/lnks  | Indicates a Data Vault 2.0 link data set created from the dbtvault link macro. |
    | lsat_     | /models/raw_vault/sats  | Indicates a Data Vault 2.0 link satellite data set created from the dbtvault satellite macro. |
    | pit_      | /models/biz_vault/pits  | Indicates a Data Vault 2.0 point-in-time table created from the dbtvault pit macro by combinining a hub/lnk and its related satellites. <br/><br/> <strong><em>Example</strong></em>: <br>Customer data comes from multiple sources so we want to see a customer record at any point-in-time integrating multiple sources. <br/><br/> <em>Step 1</em>: Models to populate the raw_vault for each source:<br/><ul><li>hub_customer.sql</li><li>hsat_customer_name_jaffle_shop.sql</li><li>hsat_customer_ids_mdm.sql</li></ul><br/><em>Step 2</em>: A pit model to join all customer data as one entity for use in downstream modeling:<ul><li>pit_customers.sql</li></ul> |
    | brg_      | /models/biz_vault/brgs  | Indicates a Data Vault 2.0 bridge table created from the dbtvault macro.  |
    | dim_      | /models/info_mart/dims  | Indicates a type 1 or type 2 dimension table. This is a final data which is robust, versatile, and ready for consumption in analytics. |
    | fact_     | /models/info_mart/facts | Indicates a fact table. This is a final data which is robust, versatile, and ready for consumption in analytics. It should include referential integrity tests to all related dimenions. |
  
  </details>

  <details>

  <summary>Uncommon</summary>

    | dag_stage | Typically found in     | description                                                        |
    |-----------|------------------------|--------------------------------------------------------------------|
    | sat_      | /models/biz_vault/sats | Indicates a computed satellite modeled in the form of a Data Vault 2.0 satellite to store repeatable logic & computations for use downstream in analytics. |
    | lnk_      | /models/biz_vault/lnks | Indicates an exploratory link or current link (i.e. latest record from link with accompanying effectivity satellite). |
    | src_      | /models/source_mart    | Indicates a data set modeled to recompose the source from the various raw vault objects. |    
    | tst_      | /models/unit_test      | Indicates a data set that is used to audit and/or unit test for developers. |

  </details>

### Model File Naming and Coding

- All objects should be plural.  
  Example: `stg_stripe__invoices.sql` vs. `stg_stripe__invoice.sql`

- All objects should have a prefix to indicate their DAG stage in the flow.  
  See [Model Layers](#model-layers) for more information.

- All models should use the naming convention `<type/dag_stage>_<source/topic>__<additional_context>`. See [this article](https://docs.getdbt.com/blog/stakeholder-friendly-model-names) for more information.
  - For models in the **marts** folder `__<additional_context>` is optional. 
  - Models in the **staging** folder should use the source's name as the `<source/topic>` and the entity name as the `additional_context`.

    Examples:
    - seed_snowflake_spend.csv
    - base_stripe__invoices.sql
    - stg_stripe__customers.sql
    - stg_salesforce__customers.sql
    - int_customers__unioned.sql
    - fct_orders.sql

- Schema, table and column names should be in `snake_case`.

- Limit use of abbreviations that are related to domain knowledge. An onboarding
  employee will understand `current_order_status` better than `current_os`.

- Use names based on the _business_ terminology, rather than the source terminology.

- Each model should have a primary key that can identify the unique row, and should be named `<object>_id`, e.g. `account_id` – this makes it easier to know what `id` is being referenced in downstream joined models.

- If a surrogate key is created, it should be named `<object>_sk`.

- For `base` or `staging` models, columns should be ordered in categories, where identifiers are first and date/time fields are at the end.  
  Example:
  ```sql
  transformed as (
      select
          -- ids
          order_id,
          customer_id,

          -- dimensions
          order_status,
          is_shipped,

          -- measures
          order_total,

          -- date/times
          created_at,
          updated_at,

          -- metadata
          _sdc_batched_at
      from source
  )
  ```

- Date/time columns should be named according to these conventions:
  - Timestamps: `<event>_at`  
    Format: UTC  
    Example: `created_at`
  
  - Dates: `<event>_date`  
    Format: Date  
    Example: `created_date`

- Booleans should be prefixed with `is_` or `has_`.  
  Example: `is_active_customer` and `has_admin_access`

- Price/revenue fields should be in decimal currency (e.g. `19.99` for $19.99; many app databases store prices as integers in cents). If non-decimal currency is used, indicate this with suffix, e.g. `price_in_cents`.

- Avoid using reserved words (such as [these](https://docs.snowflake.com/en/sql-reference/reserved-keywords.html) for Snowflake) as column names.

- Consistency is key! Use the same field names across models where possible.  
Example: a key to the `customers` table should be named `customer_id` rather than `user_id`.

### Model Configurations

- Model configurations at the [folder level](https://docs.getdbt.com/reference/model-configs#configuring-directories-of-models-in-dbt_projectyml) should be considered (and if applicable, applied) first.
- More specific configurations should be applied at the model level [using one of these methods](https://docs.getdbt.com/reference/model-configs#apply-configurations-to-one-model-only).
- Models within the `marts` folder should be materialized as `table` or `incremental`.
  - By default, `marts` should be materialized as `table` within `dbt_project.yml`.
  - If switching to `incremental`, this should be specified in the model's configuration.

### Unit Testing
At a minimum, developers need to perform the following unit tests before creating their Pull Request. Screenshots of the successful unit tests should be included as part of your pull request in the [Validation of models](https://github.com/Hakkoda1/dbt_capstone_solution/blob/main/pull_request_template.md#validation-of-models) section.

  1. [Compare Row Counts](https://github.com/dbt-labs/dbt-audit-helper/tree/0.6.0/#compare_relations-source) 
  This test will ensure that all rows have arrived in the target when compared to the source. Add a screenshot of the unit test preview from the dbt Cloud UI in your pull request similar to the table below:

      | in_a | in_b | count | percent_of_total |
      |----|----|----|----|
      | True   | True | 9500 | 100.00 |

  2. [Compare Column data types](https://github.com/dbt-labs/dbt-audit-helper#compare_relation_columns-source)
  This test will ensure that all data types & ordinal positions align between the source and target.  Add a screenshot of the unit test preview from the dbt Cloud UI in your pull request similar to the table below:

      | column_name	| a_ordinal_position	| b_ordinal_position	| a_data_type |	b_data_type |
      |-----------|-----------|-----------|-----------|-----------|
      |patient_skey	| 1	| 1	| binary	| binary |
      |patient_id	| 2	| 2	| varchar	| varchar |
      |birth_date	| 3	| 3	| timestamp	| date | 

  3. [Compare Column Values](https://github.com/dbt-labs/dbt-audit-helper/tree/0.6.0/#compare_all_columns-source) 
  This test will compare column values between the source and target.  Add a screenshot of the unit test preview from the dbt Cloud UI in your pull request.

### Testing
- At a minimum, `unique` and `not_null` tests should be applied to the primary key and natural key of each model.
  - If a key is represented by a combination of fields, use the [dbt_constraints](https://github.com/Snowflake-Labs/dbt_constraints) package created by Snowflake Labs to define a combination key and apply test as shown in this example:
  ```yaml
  version: 2

  models:

    - name: hsat_customer_name_jaffle_shop
      description: Descriptive information for Customers from Jaffle Shop.              
      tests:
        - dbt_constraints.primary_key:
            column_names:
              - hub_customer_hkey
              - load_datetime
  ```
- For facts and dimensions, referential integrity tests should be applied to the primary key of each relating model. The referential integrity tests can be created using the out-of-box `relationships` test or the `dbt-constraints.foreign_key` test.
  #### Example referential integrity test using `relationships`:
  ```yaml
  version: 2

  models:
    - name: orders
      columns:
        - name: customer_id
          tests:
            - relationships:
                to: ref('customers')
                field: id
  ```
  
  #### Example referential integrity test using `dbt-constraints.foreign_key`:
  ```yaml
  version: 2

  models:
  
    - name: lnk_order_customer
      description: A distinct list of the relationship between Orders and Customers from Jaffle Shop.
      tags: ['order','jaffle_shop']
      columns:
        - name: hub_order_hkey
          tests:
            - dbt_constraints.foreign_key:
                pk_table_name: ref('hub_order')
                pk_column_name: hub_order_hkey
        - name: hub_customer_hkey
          tests:
            - dbt_constraints.foreign_key:
                pk_table_name: ref('hub_customer')
                pk_column_name: hub_customer_hkey  
  ```
- Use the out-of-box dbt tests and/or packages such as [dbt-utils]() and [dbt-expectations](). In the event these packages do not include a test that meets your requirements, create a generic test.
- Additional tests should be applied based on business need for tests like ranges of values, thresholds for metrics, etc.

#### Testing & Snowflake Zero Copy Cloning

### Branching Strategy
Our pull requests (typically) fit into four main categories:

| Category | Description                                             |
|----------|---------------------------------------------------------|
| Feature      | Branch for adding a new object or functionality in dbt (i.e. a new model, macro, seed, etc)       |
| Fix  | Branch for modifying an existing object in dbt.       |
| Test  | Branch for adding a dbt test or documentation |
| Update  | Branch for updating dbt packages or dbt_project.yml |

The following diagram highlights the branching strategy defined for the project:

![image](https://drive.google.com/uc?export=view&id=1F5iwwkFwbJ1fO1LwOnlUn69_C9FS2VRk)

### Deployment Workflow 
1. Developer creates a branch from QA and names it feature, fix or test and makes their changes or additions.
2. Developer unit tests their changes or additions against a clone of PROD (or QA)
3. A PR is created by the developer from their feature/fix/test branch to QA branch
4. PR is automatically labeled feature, fix or test based on the naming convention of “feature/logical-feature-name” by GitHub PR Labeler action.
5. PR is reviewed and merged into QA branch by an admin
6. QA job is run and QA/UAT is performed on the change/addition 
7. Once ready for production, an admin uses Github  action ‘Draft a new release’ to trigger creation of a release branch PR to the PROD branch.
8. After the release branch PR is merged a second Github action triggers creation of  a git Release and generates release notes.

### Pull Request Template
[This pull request template]([pull_request_template.md](https://github.com/Hakkoda1/dbt_capstone_solution/blob/main/pull_request_template.md#validation-of-models)), located in the root of our repository, has been created to standardize pull requests across the project team. For reference, review [this article from dbt-Labs](https://docs.getdbt.com/blog/analytics-pull-request-template) describes the importance of having a standardized template for pull requests and provides screenshots of a completed pull request as a guide.

### CTEs

For more information about why we use so many CTEs, check out [this glossary entry](https://docs.getdbt.com/terms/cte).

- Where performance permits, CTEs should perform a single, logical unit of work.

- CTE names should be as verbose as needed to convey what they do.

- CTEs with confusing or noteable logic should be commented with SQL comments as you would with any complex functions, and should be located above the CTE.

- CTEs that are duplicated across models should be pulled out and created as their own models.

- CTEs fall in to two main categories:
  | Term    | Definition                                                                                                                                                             |
  |---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  | Import  | Used to bring data into a model. These are kept relatively simple and refrain from complex operations such as joins and column transformations.                        |
  | Logical | Used to perform a logical step with the data that is brought into the model toward the end result. |

- All `{{ ref() }}` or `{{ source() }}` statements should be placed within import CTEs so that dependent model references are easily seen and located.

- Where applicable, opt for filtering within import CTEs over filtering within logical CTEs. This allows a developer to easily see which data contributes to the end result.

- SQL should end with a simple select statement. All other logic should be contained within CTEs to make stepping through logic easier while troubleshooting.
  Example: `select * from final`

- SQL and CTEs within a model should follow this structure:
  - `with` statement
  - Import CTEs
  - Logical CTEs
  - Simple select statement

#### Example SQL with CTEs

  ``` sql
   -- Jaffle shop went international!
  with

  -- Import CTEs
  regions as (
      select * from {{ ref('stg_jaffle_shop__regions') }}
  ),

  nations as (
      select * from {{ ref('stg_jaffle_shop__nations') }}
  ),
  
  suppliers as (
      select * from {{ ref('stg_jaffle_shop__suppliers') }}
  ),
  
  -- Logical CTEs
  locations as (
      select
          {{ dbt_utils.surrogate_key([
              'regions.region_id',            
              'nations.nation_id'
          ]) }} as location_sk,
          regions.region_id,
          regions.region,
          regions.region_comment,
          nations.nation_id,
          nations.nation,
          nations.nation_comment
      from regions
      left join nations
          on regions.region_id = nations.region_id
  ),
  
  final as (
      select
          suppliers.supplier_id,
          suppliers.location_id,
          locations.region_id,
          locations.nation_id,
          suppliers.supplier_name,
          suppliers.supplier_address,
          suppliers.phone_number,
          locations.region,
          locations.region_comment,
          locations.nation,
          locations.nation_comment,
          suppliers.account_balance
      from suppliers
      inner join locations
          on suppliers.location_id = locations.location_sk
  )
  
  -- Simple select statement
  select * from final
  ```

### SQL style guide
- **DO NOT OPTIMIZE FOR FEWER LINES OF CODE.**  

  New lines are cheap, brain time is expensive; new lines should be used within reason to produce code that is easily read.

- Use trailing commas

- Indents should use four spaces. 

- When dealing with long `when` or `where` clauses, predicates should be on a new
  line and indented.  
  Example:
  ```sql
  where 
      user_id is not null
      and status = 'pending'
      and location = 'hq'
  ```

- Lines of SQL should be no longer than 80 characters and new lines should be used to ensure this.  
  Example:
  ```sql
  sum(
      case
          when order_status = 'complete'
              then order_total 
      end
  ) as monthly_total,



  {{ get_windowed_values(
        strategy='sum',
        partition='order_id',
        order_by='created_at',
        column_list=[
            'final_cost'
        ]
  ) }} as total_final_cost
  ```

- Use all lowercase unless a specific scenario needs you to do otherwise. This means that keywords, field names, function names, and file names
  should all be lowercased.

- The `as` keyword should be used when aliasing a field or table

- Fields should be stated before aggregates / window functions

- Aggregations should be executed as early as possible before joining to another table.

- Ordering and grouping by a number (eg. group by 1, 2) is preferred over listing the column names (see [this rant](https://blog.getdbt.com/write-better-sql-a-defense-of-group-by-1/) for why). Note that if you are grouping by more than a few columns, it may be worth revisiting your model design. If you really need to, the [dbt_utils.group_by](https://github.com/dbt-labs/dbt-utils/tree/0.8.6/macros/sql/groupby.sql) function may come in handy.

- Prefer `union all` to `union` [*](http://docs.aws.amazon.com/redshift/latest/dg/c_example_unionall_query.html)

- Avoid table aliases in join conditions (especially initialisms) – it's harder to understand what the table called "c" is compared to "customers".

- If joining two or more tables, _always_ prefix your column names with the table alias. If only selecting from one table, prefixes are not needed.

- Be explicit about your join (i.e. write `inner join` instead of `join`). `left joins` are the most common, `right joins` often indicate that you should change which table you select `from` and which one you `join` to.

- Joins should list the left table first (i.e., the table you're joining data to)  
  Example:
  ```sql
  select
      trips.*,
      drivers.rating as driver_rating,
      riders.rating as rider_rating
  from trips
  left join users as drivers
     on trips.driver_id = drivers.user_id
  left join users as riders
      on trips.rider_id = riders.user_id

  ```

#### Example SQL
  ```sql
  with

  my_data as (
      select * from {{ ref('my_data') }}
      where not is_deleted
  ),

  some_cte as (
      select * from {{ ref('some_cte') }}
  ),

  some_cte_agg as (
      select
          id,
          sum(field_4) as total_field_4,
          max(field_5) as max_field_5
      from some_cte
      group by 1
  ),

  final as (
      select [distinct]
          my_data.field_1,
          my_data.field_2,
          my_data.field_3,

          -- use line breaks to visually separate calculations into blocks
          case
              when my_data.cancellation_date is null
                  and my_data.expiration_date is not null
                  then expiration_data
              when my_data.cancellation_date is null
                  then my_data.start_date + 7
              else my_data.cancellation_date
          end as cancellation_date,

          some_cte_agg.total_field_4,
          some_cte_agg.max_field_5
      from my_data
      left join some_cte_agg  
          on my_data.id = some_cte_agg.id
      where 
          my_data.field_1 = 'abc'
          and (
              my_data.field_2 = 'def'
              or my_data.field_2 = 'ghi'
          )
      qualify row_number() over(
          partition by my_data.field_1
          order by my_data.start_date desc
      ) = 1
  )

  select * from final
  ```

### YAML and Markdown style guide

- Every subdirectory contains their own `.yml` file(s) which contain configurations for the models within the subdirectory.

- YAML and markdown files should be prefixed with an underscore ( `_` ) to keep it at the top of the subdirectory.

- YAML and markdown files should be named with the convention `_<description>__<config>`.  

  Examples: `_jaffle_shop__sources.yml`, `_jaffle_shop__docs.md`  

  - `description` is typically the folder of models you're setting configurations for.  
    Examples: `core`, `staging`, `intermediate`
  - `config` is the top-level resource you are configuring.  
    Examples: `docs`, `models`, `sources`
- Indents should use two spaces.

- List items should be indented.

- Use a new line to separate list items that are dictionaries, where appropriate.

- Lines of YAML should be no longer than 80 characters.

- Items listed in a single .yml or .md file should be sorted alphabetically for ease of finding in larger files.

- Each top-level configuration should use a separate `.yml` file (i.e, sources, models)
  Example:
  ```bash
  models
  ├── marts
  └── staging
      └── jaffle_shop
          ├── _jaffle_shop__docs.md

          ├── _jaffle_shop__models.yml
          ├── _jaffle_shop__sources.yml
          ├── stg_jaffle_shop__customers.sql
          ├── stg_jaffle_shop__orders.sql
          └── stg_jaffle_shop__payments.sql
  ```

#### Example YAML
  `_jaffle_shop__models.yml`:

  ```yaml
  version: 2

  models:
  
    - name: base_jaffle_shop__nations

      description: This model cleans the raw nations data
      columns:
        - name: nation_id
          tests:
            - unique
            - not_null   

    - name: base_jaffle_shop__regions
      description: >
        This model cleans the raw regions data before being joined with nations
        data to create one cleaned locations table for use in marts.
      columns:
        - name: region_id
          tests:
            - unique
            - not_null

    - name: stg_jaffle_shop__locations

      description: "{{ doc('jaffle_shop_location_details') }}"

      columns:
        - name: location_sk
          tests:
            - unique
            - not_null
  ```

  #### Example Markdown
  `_jaffle_shop__docs.md`:

  ```markdown
    {% docs enumerated_statuses %}
      
      Although most of our data sets have statuses attached, you may find some
      that are enumerated. The following table can help you identify these statuses.
      | Status | Description                                                                 |
      |--------|---------------|
      | 1      | ordered       |
      | 2      | shipped       |
      | 3      | pending       |
      | 4      | order_pending | 

      
  {% enddocs %}

  {% docs statuses %} 

      Statuses can be found in many of our raw data sets. The following lists
      statuses and their descriptions:
      | Status        | Description                                                                 |
      |---------------|-----------------------------------------------------------------------------|
      | ordered       | A customer has paid at checkout.                                            |
      | shipped       | An order has a tracking number attached.                                    |
      | pending       | An order has been paid, but doesn't have a tracking number.                 |
      | order_pending | A customer has not yet paid at checkout, but has items in their cart. | 

  {% enddocs %}
```

### Jinja style guide

- Jinja delimiters should have spaces inside of the delimiter between the brackets and your code.  
  Example: `{{ this }}` instead of `{{this}}`

- Use [whitespace control](https://jinja.palletsprojects.com/en/3.1.x/templates/#whitespace-control) to make compiled SQL more readable.

- An effort should be made for a good balance in readability for both templated 
and compiled code. However, opt for code readability over compiled SQL readability
when needed.

- A macro file should be named after the _main_ macro it contains.

- A file with more than one macro should follow these conventions:
  - There is one macro which is the main focal point
  - The file is named for the main macro or idea
  - All other macros within the file are only used for the purposes of the main 
    idea and not used by other macros outside of the file.

- Use new lines to visually indicate logical blocks of Jinja or to enhance readability.  
  Example:  
  ```jinja 
  {%- set orig_cols = adapter.get_columns_in_relation(ref('fct_orders')) %}

  {%- set new_cols = dbt_utils.star(
        from=ref('fct_order_items'),
        except=orig_cols
  ) %}

  -- original columns. {{ col }} is indented here, but choose what will satisfy
  -- your own balance for Jinja vs. SQL readability. 
  {%- for col in orig_cols %}
        {{ col }}
  {% endfor %}

  -- column difference
  {{ new_cols }}
  ```

- Use new lines within Jinja delimiters and arrays if there are multiple arguments.  
  Example:
  ```jinja
  {%- dbt_utils.star(
        from=ref('stg_jaffle_shop__orders'),
        except=[
            'order_id',
            'ordered_at',
            'status'
        ],
        prefix='order_'
  ) %}
  ```

### Metrics style guide

#### Organizing Metrics

* Metrics are categorized by entity (object grain that the metrics occurs), and filenames directly correspond to metrics.  
  Filenames are prefixed with `base__` only if they are pre-calculated inputs to derived metrics in other files.
  ```
  ├── dbt_project.yml
  └── models
      ├── marts
      ├── staging
      └── metrics
          ├── projects
          |   ├── active_projects.yml
          ├── accounts
          |   ├── active_cloud_accounts.yml
          └── users
              ├── base__net_promoter_score.yml
              └── net_promoter_score.yml

  ```

#### Metrics Conventions

dbt Metrics fall into four broad categories:
1. Company metrics
2. Team KPIs
3. OKRs
4. Specific metrics related to a product area, business unit, or business function that is not necessarily a team KPI, but important to track nonetheless.

Because of the wide socialization of these docs and downstream usage in the BI layer, consistency and clarity are _very_ important. Below are the general standards and examples of how we format and implement metrics at dbt Labs:
* Metrics names must begin with a letter, cannot contain whitespace, and should be all lowercase.
* The [minimum required properties](https://docs.getdbt.com/docs/building-a-dbt-project/metrics#available-properties) must be present in the metric definition.
* Tags and/or Meta properties should match the categories above and be used to organize metrics at the category or business function level.
* Meta properties should be used to track metric definition ownership.
* For up-to-date information on metrics, please see the [metrics docs on defining a metric](https://docs.getdbt.com/docs/building-a-dbt-project/metrics#defining-a-metric) or the [dbt-labs/metrics README](https://github.com/dbt-labs/dbt_metrics#readme)

#### Example Metrics YAML
```yaml
version: 2

metrics:
  - name: base__total_nps_respondents_cloud
    label: (Base) Total of NPS Respondents (Cloud)
    model: ref('fct_customer_nps')
    description: >
      'The count of users responding to NPS surveys in dbt Cloud.'
    tags: ['Company Metric']

    calculation_method: count
    expression: unique_id

    timestamp: created_at
    time_grains: [day, month, quarter, year]

    dimensions:
      - feedback_source

    filters:
      - field: feedback_source
        operator: '='
        value: "'dbt_cloud_nps'"

    meta:
      metric_level: 'Company'
      owner(s): 'Jane Doe'


  - name: base__count_nps_promoters_cloud
    label: (Base) Count of NPS Promoters (Cloud)
    model: ref('fct_customer_nps')
    description: >
      'The count of dbt Cloud respondents that fall into the promoters segment.'
    tags: ['Company Metric']

    calculation_method: count
    expression: unique_id

    timestamp: created_at
    time_grains: [day, month, quarter, year]

    filters:
      - field: feedback_source
        operator: '='
        value: "'dbt_cloud_nps'"
      - field: nps_category
        operator: '='
        value: "'promoter'"

    meta:
      metric_level: 'Company'
      owner(s): 'Jane Doe'

  - name: promoters_pct
    label: Percent Promoters (Cloud)
    description: 'The percent of dbt Cloud users in the promoters segment.'
    tags: ['Company Metric']

    calculation_method: derived
    expression: "{{metric('base__count_nps_promoters_cloud')}} / {{metric('base__total_nps_respondents_cloud')}}" 

    timestamp: created_at
    time_grains: [day, month, quarter, year]

    meta:
      metric_level: 'Company'
      owner(s): 'Jane Doe'
```

