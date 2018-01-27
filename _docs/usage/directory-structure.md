# Guide to Exekube directory structure and framework usage

## Generic modules

Generic modules are normal Terraform modules, just like the ones you can find at <https://modules.terraform.io>.

Generic modules are **same across different deployment environments**.

Currently, Exekube ships with two built-in modules:

- [gcp-gke](/) module, which can create a Kubernetes cluster and a auto-scaling node-pool on Google Kubernetes Engine
- [helm-release](/) module, which can deploy (release) a Helm chart onto a Kubernetes cluster

## Live modules

Live modules are applicable / executable modules, the modules that will be located in the `live` directory and applied by Terraform. Exekube uses [Terragrunt](https://github.com/gruntwork-io/terragrunt) as a wrapper around Terraform to to reduce boilerplate code for live modules and manage multiple live modules at once.

Live modules are instances of generic modules configured for a specific deployment environment. Live modules are always **different across different deployment environments**.

If you run `xk apply`, you are applying **all live modules**, so it is equivalent of running `xk apply $XK_LIVE_DIR`. Under the cover, `xk apply` calls `terragrunt apply-all`.

You can also apply an individual live module by running `xk apply <live-module-path>` or groups of live modules by running `xk apply <directory-structure-of-live-modules>`.

## Further reading

The [README for the framework default live module directory](https://github.com/ilyasotkov/exekube/tree/develop/live) goes further into explaining how live modules are structured.