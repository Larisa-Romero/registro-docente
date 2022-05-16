# Disaster recovery

This documentation covers one scenario:

- [Data loss](#data-loss)

In case of any of the above disaster scenario, please do the following:

### Freeze pipeline

Alert all developers that no one should merge to main branch.

### Local Dependencies

You will need the [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and [cf](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) CLIs installed as well as [make](https://www.gnu.org/software/make/) and either [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) or [tfenv](https://github.com/tfutils/tfenv#installation).

### Maintenance mode

In the instance of data loss it will probably be desirable to enable [Maintenance mode](maintenance-mode.md) to ensure that the database is only read from and written to when it is back in it's expected state.

### Set up a virtual meeting

Set up virtual meeting via Zoom, Slack, Teams or Google Hangout, inviting all the relevant technical stakeholders. Regularly provide updates on
the #twd_publish Slack channel to keep product owners abreast of developments.

### Internet Connection

Ensure whoever is executing the process has a reliable and reasonably fast Internet connection.

## Data Loss

In the case of a data loss, we need to recover the data as soon as possible in order to resume normal service. Declare a major incident and document the incident timelines as you go along.

The application's database is a postgres instance, which resides on PaaS. This provides a point-in-time backup with the resolution of 1 second, available between 5min and 7days. We can use terraform to create a new database instance and use a point-in-time backup from the corrupted instance to restore the data.  This will be done in a single terraform apply operation.

### Make note of database failure time

Make note of the time the database failure occurred, and then use this to calculate when the integrity of the data in the database was still viable. For instance, if data loss or corruption happened at 1200hrs, use this to work out what snapshot time is best for the product (consult with the PM if you are unsure what would be best from the product perspective). This would determine the value of `SNAPSHOT_TIME` env.

Important: You should convert the time to UTC before actually using it. When you record the time, note what timezone you are using. Especially during BST (British Summer Time).

### Get affected postgres database ID

Use the makefile's get-postgres-instance-guid to get the database guid, use the following command:

```
make <env> get-postgres-instance-guid [CONFIRM_PRODUCTION=true]
```
env is the target environment e.g. production


### Rename postgres database instance service

Rename the affected database instance so a new database can be recreated with the production name. To achieve this, run the following make command

```
make <env> rename-postgres-service passcode=xxxx [CONFIRM_PRODUCTION=true]
```
this renames the database by appending "-old" to the database name, env is the target environment e.g. production, obtain a passcode from [GOV.UK PaaS one-time passcode](https://login.london.cloud.service.gov.uk/passcode)

### Remove affected postgres database instance from terraform state file

In order for terraform to be able to create a new database instance, the existing database reference needs to be removed from the state file. This is to ensure it is no longer managed by terraform, otherwise, terraform would revert our changes. To achieve this, use the makefile target -

```
az login # authenticate to Azure because statefile is in an Azure Storage Container
make <env> remove-postgres-tf-state [CONFIRM_PRODUCTION=true]
```
env is the target environment e.g. production

### Restore postgres database instance

The following variables need to be set: DB_INSTANCE_GUID (the output of the 'Get affected postgres instance guid' step, SNAPSHOT_TIME ("2021-09-14 16:00:00" IMPORTANT - this is UTC time!), passcode (a passcode from [GOV.UK PaaS one-time passcode](https://login.london.cloud.service.gov.uk/passcode)), CONFIRM_PRODUCTION (true) and tag (the docker tag for the application image).

The following commands combine the makefile recipes above to initiate the restore process by using the approriate variable values:

```
# env is the target environment in the make file e.g. 'production'
# space is the name of the environment in GOV.UK PaaS, eg 'bat-prod'
az login
cf login -o dfe -s <space> -u my.name@digital.education.gov.uk
PASSCODE=xxxx # obtain from https://login.london.cloud.service.gov.uk/passcode
DB_INSTANCE_GUID=$(make <env> get-postgres-instance-guid)
TAG=$(make <env> get-image-tag)
make <env> rename-postgres-service PASSCODE=${PASSCODE} CONFIRM_PRODUCTION=true
make <env> remove-postgres-tf-state PASSCODE=${PASSCODE} CONFIRM_PRODUCTION=true
make <env> restore-postgres DB_INSTANCE_GUID=${DB_INSTANCE_GUID} SNAPSHOT_TIME="yyyy-mm-dd HH:MM:ss" PASSCODE=${PASSCODE} IMAGE_TAG=${TAG} CONFIRM_PRODUCTION=true
```

You will be prompted to review the terraform plan.  Check for the following:
- the `cloudfoundry_app.docker_image` tags are **not** changing
- a new database instance is being created using a point-in-time database backup of corrupted database
- new service keys are created

The restore process should take ~25 min.  Terraform should write logs to the console with progress, the bulk of the time will be spent recreating the postgres instance.

### PaaS documentation

Gov UK PaaS Documentation on Point-in-time database recovery can be found [here](https://docs.cloud.service.gov.uk/deploying_services/postgresql/#restoring-a-postgresql-service-from-a-point-in-time)

### Tidy up

Once the database has been successfully restored, the corrupted database instance should be deleted.

```
cf delete-service register-postgres-<env>-old -f
```