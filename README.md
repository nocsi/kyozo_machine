# KyozoStore

KyozoStore is a self-hosted implementation of the [Vagrant Cloud API](https://www.vagrantup.com/docs/vagrant-cloud/api.html). 
It's purpose is to allow for private hosting of Vagrant boxes without relying on external services. KyozoStore currently supports

* Vagrant Box Catalog
* Vagrant Box Creation
* Vagrant Box Versioning
* Vagrant Box Version Provider 
* Minio Blob Storage
* KeyCloak OAuth2

To start your KyozoStore:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start KyozoStore endpoint with `mix phx.server`

## Featurse

* Storage of Vagrant Boxes through any Minio supported Blob Storage Provider
* OAuth2 support, tested with KeyCloak

**Coming Soon**

* Terraform API 
* Packer API
* Vagrant Share support

## Environment Variables

### Server

The following env variables need to be considered for running a KyozoStore
server:

**MINIO**
* MINIO_BUCKET
* MINIO_HOST
* MINIO_ACCESS_KEY
* MINIO_ACESSS_SECRET

**KEYCLOAK**
* KEYCLOAK_PUBK
* KEYCLOAK_SITE
* KEYCLOAK_REALM

**KEYCLOAK_KYOZOSTORE**
* KEYCLOAK_CLIENT_ID
* KEYCLOAK_CLIENT_SECRET

**KYOZOSTORE**
* KYOZO_DB_HOST
* KYOZO_DB_NAME
* KYOZO_DB_USER
* KYOZO_DB_PASS
* KYOZO_SERET_KEY
* KYOZO_SERET_KEY_BASE

### Client
**
The following env variables need to be considered for utilizing a vagrant client
with KyozoStore:

* VAGRANT_CLOUD_TOKEN//ATLAS_TOKEN
  * vagrant login
* VAGRANT_SERVER_URL
  * https://kyozostore.com
