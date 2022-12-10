# Ampere A1 OKE Cluster

Terraform script that helps you provision OKE cluster running on A1 on OCI

**Ampere A1** 

Ampere A1 is one of the most cost effective chips available in the market, it allows for low cost computing that can be leveraged for special scenarios, such as parallel computing and webhosting.

The script will provision a cluster with 2 nodes (both on the same AD) on 2 OCPUs each. In the configuration section we'll show how to modify the number of nodes and OCPUs.

The script will then provision nginx (2 pods) and explose it behind a load balancer.

## Requirements
OCI tenancy
An OCI compartment

## Configuration

1. Log into cloud console 
2. run the following 
```
git clone https://github.com/badr42/OKE_A1
cd OKE_A1
export TF_VAR_tenancy_ocid='<tenancy-ocid>'
export TF_VAR_compartment_ocid='<comparment-ocid>'
export TF_VAR_region='<home-region>'
<optional>
### Select Availability Domain, zero based, if not set it defaults to 0, this allows you to select an AD that has available A1 chips
export TF_VAR_AD_number='0'

### Select number of nodes
export TF_VAR_node_count='2'

### Set OCPU count per node
export TF_VAR_ocpu_count='2'

```



## Build
To build simply execute the next commands. 
```
terraform init
terraform plan
terraform apply
```


**After applying, the service will be ready in about 25 minutes**  



## Post configuration

You should be able to get your nginx LB IP by running the following command 

```
kubectl  --kubeconfig kubeconfig get service

```


the result should look like and you can see the external IP of the LB
![results] (https://github.com/badr42/oke_A1/blob/main/images/results.png)


## Terminating the environment
When are done please run

```
terraform destroy

```

