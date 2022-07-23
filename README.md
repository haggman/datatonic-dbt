# DBT in GCP's Cloud Composer

Composer 2 instance was Terraformed with a private IP, so before this works, you need to setup a namespace and configure the Workload Identity, or you will get an auth error.

The following set of steps is based on standard GKE Workload Identity stuff. See [this](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to). I created the Composer instance, the DBT for SA to use, and set the permissions all using Terraform. If you want to see, the Terraform project may be found [here](https://github.com/haggman/datatonic-infra)

Assuming the cluster is build and running, you will need to:

1. Setup a VM in your project, preferably without an external IP, and then SSH into it using IAP.

1. Use `glcoud init` to get gcloud setup on the VM
2. Install kubectl in the VM `sudo apt-get install kubectl`
3. Once gcloud is co3nfigured and you've added kubectl, use the standard approach to setting up your .kube/config file. 

``` bash
gcloud container clusters get-credentials compser-cluster-name --region region-where-it-lives --project owning-project
```

4. From the VM, add a new namespace for the DBT app.

``` bash
kubectl create namespace dbt-pipelines
```

5. Create a new NS in K8S for dbt to use

``` bash
kubectl create serviceaccount sa-gke-dbt \
    --namespace dbt-pipelines
```
