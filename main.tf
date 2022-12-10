provider "oci" {}


# data "oci_core_images" "images" {
#   compartment_id = var.compartment_ocid
#   operating_system = "Oracle-Linux"
#   shape = var.instance_shape
# }


# data "oci_identity_region_subscriptions" "test_region_subscriptions" {
#     #Required
#     tenancy_id = oci_identity_tenancy.test_tenancy.id
    
# }


data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.compartment_ocid
}


resource "oci_core_vcn" "generated_oci_core_vcn" {
	cidr_block = "10.0.0.0/16"
	compartment_id = var.compartment_ocid
	display_name = "oke-vcn-A1Cluster-dbb86c919"
	dns_label = "A1Cluster"
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
	compartment_id = var.compartment_ocid
	display_name = "oke-igw-A1cluster1-dbb86c919"
	enabled = "true"
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_nat_gateway" "generated_oci_core_nat_gateway" {
	compartment_id = var.compartment_ocid
	display_name = "oke-ngw-A1Cluster-dbb86c919"
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_service_gateway" "generated_oci_core_service_gateway" {
	compartment_id = var.compartment_ocid
	display_name = "oke-sgw-A1Cluster-dbb86c919"
	services {
		service_id = "ocid1.service.oc1.eu-frankfurt-1.aaaaaaaa7ncsqkj6lkz36dehifizupyn6qjqsmtepsegs23yyntnsy7qrvea"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_route_table" "generated_oci_core_route_table" {
	compartment_id = var.compartment_ocid
	display_name = "oke-private-routetable-cluster1-dbb86c919"
	route_rules {
		description = "traffic to the internet"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		network_entity_id = "${oci_core_nat_gateway.generated_oci_core_nat_gateway.id}"
	}
	route_rules {
		description = "traffic to OCI services"
		destination = "all-fra-services-in-oracle-services-network"
		destination_type = "SERVICE_CIDR_BLOCK"
		network_entity_id = "${oci_core_service_gateway.generated_oci_core_service_gateway.id}"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_subnet" "service_lb_subnet" {
	cidr_block = "10.0.20.0/24"
	compartment_id = var.compartment_ocid
	display_name = "oke-svclbsubnet-A1Cluster-dbb86c919-regional"
	dns_label = "lbsub2f0738735"
	prohibit_public_ip_on_vnic = "false"
	route_table_id = "${oci_core_default_route_table.generated_oci_core_default_route_table.id}"
	security_list_ids = ["${oci_core_vcn.generated_oci_core_vcn.default_security_list_id}"]
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_subnet" "node_subnet" {
	cidr_block = "10.0.10.0/24"
	compartment_id = var.compartment_ocid
	display_name = "oke-nodesubnet-A1Cluster-dbb86c919-regional"
	dns_label = "subf3f9db2b8"
	prohibit_public_ip_on_vnic = "true"
	route_table_id = "${oci_core_route_table.generated_oci_core_route_table.id}"
	security_list_ids = ["${oci_core_security_list.node_sec_list.id}"]
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
	cidr_block = "10.0.0.0/28"
	compartment_id = var.compartment_ocid
	display_name = "oke-k8sApiEndpoint-subnet-quick-cluster1-dbb86c919-regional"
	dns_label = "sub122a07b87"
	prohibit_public_ip_on_vnic = "false"
	route_table_id = "${oci_core_default_route_table.generated_oci_core_default_route_table.id}"
	security_list_ids = ["${oci_core_security_list.kubernetes_api_endpoint_sec_list.id}"]
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_default_route_table" "generated_oci_core_default_route_table" {
	display_name = "oke-public-routetable-cluster1-dbb86c919"
	route_rules {
		description = "traffic to/from internet"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		network_entity_id = "${oci_core_internet_gateway.generated_oci_core_internet_gateway.id}"
	}
	manage_default_resource_id = "${oci_core_vcn.generated_oci_core_vcn.default_route_table_id}"
}

resource "oci_core_security_list" "service_lb_sec_list" {
	compartment_id = var.compartment_ocid
	display_name = "oke-svclbseclist-A1cluster-dbb86c919"
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_security_list" "node_sec_list" {
	compartment_id = var.compartment_ocid
	display_name = "oke-nodeseclist-A1cluster1-dbb86c919"
	egress_security_rules {
		description = "Allow pods on one worker node to communicate with pods on other worker nodes"
		destination = "10.0.10.0/24"
		destination_type = "CIDR_BLOCK"
		protocol = "all"
		stateless = "false"
	}
	egress_security_rules {
		description = "Access to Kubernetes API Endpoint"
		destination = "10.0.0.0/28"
		destination_type = "CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "Kubernetes worker to control plane communication"
		destination = "10.0.0.0/28"
		destination_type = "CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "Path discovery"
		destination = "10.0.0.0/28"
		destination_type = "CIDR_BLOCK"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		stateless = "false"
	}
	egress_security_rules {
		description = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
		destination = "all-fra-services-in-oracle-services-network"
		destination_type = "SERVICE_CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "ICMP Access from Kubernetes Control Plane"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		stateless = "false"
	}
	egress_security_rules {
		description = "Worker Nodes access to Internet"
		destination = "0.0.0.0/0"
		destination_type = "CIDR_BLOCK"
		protocol = "all"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Allow pods on one worker node to communicate with pods on other worker nodes"
		protocol = "all"
		source = "10.0.10.0/24"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Path discovery"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		source = "10.0.0.0/28"
		stateless = "false"
	}
	ingress_security_rules {
		description = "TCP access from Kubernetes Control Plane"
		protocol = "6"
		source = "10.0.0.0/28"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Inbound SSH traffic to worker nodes"
		protocol = "6"
		source = "0.0.0.0/0"
		stateless = "false"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_core_security_list" "kubernetes_api_endpoint_sec_list" {
	compartment_id = var.compartment_ocid
	display_name = "oke-k8sApiEndpoint-A1cluster1-dbb86c919"
	egress_security_rules {
		description = "Allow Kubernetes Control Plane to communicate with OKE"
		destination = "all-fra-services-in-oracle-services-network"
		destination_type = "SERVICE_CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "All traffic to worker nodes"
		destination = "10.0.10.0/24"
		destination_type = "CIDR_BLOCK"
		protocol = "6"
		stateless = "false"
	}
	egress_security_rules {
		description = "Path discovery"
		destination = "10.0.10.0/24"
		destination_type = "CIDR_BLOCK"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		stateless = "false"
	}
	ingress_security_rules {
		description = "External access to Kubernetes API endpoint"
		protocol = "6"
		source = "0.0.0.0/0"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Kubernetes worker to Kubernetes API endpoint communication"
		protocol = "6"
		source = "10.0.10.0/24"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Kubernetes worker to control plane communication"
		protocol = "6"
		source = "10.0.10.0/24"
		stateless = "false"
	}
	ingress_security_rules {
		description = "Path discovery"
		icmp_options {
			code = "4"
			type = "3"
		}
		protocol = "1"
		source = "10.0.10.0/24"
		stateless = "false"
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"
}

resource "oci_containerengine_cluster" "generated_oci_containerengine_cluster" {
	compartment_id = var.compartment_ocid
	endpoint_config {
		is_public_ip_enabled = "true"
		subnet_id = "${oci_core_subnet.kubernetes_api_endpoint_subnet.id}"
	}
	freeform_tags = {
		"OKEclusterName" = "A1Cluster"
	}
	kubernetes_version = "v1.24.1"
	name = "A1Cluster"
	options {
		admission_controller_options {
			is_pod_security_policy_enabled = "false"
		}
		persistent_volume_config {
			freeform_tags = {
				"OKEclusterName" = "A1Cluster"
			}
		}
		service_lb_config {
			freeform_tags = {
				"OKEclusterName" = "A1Cluster"
			}
		}
		service_lb_subnet_ids = ["${oci_core_subnet.service_lb_subnet.id}"]
	}
	vcn_id = "${oci_core_vcn.generated_oci_core_vcn.id}"



}




resource "oci_containerengine_node_pool" "create_node_pool_details0" {
	cluster_id = "${oci_containerengine_cluster.generated_oci_containerengine_cluster.id}"
	compartment_id = var.compartment_ocid 
	freeform_tags = {
		"OKEnodePoolName" = "pool1"
	}
	initial_node_labels {
		key = "name"
		value = "cluster2"
	}
	kubernetes_version = "v1.24.1"
	name = "pool1"
	node_config_details {
		freeform_tags = {
			"OKEnodePoolName" = "pool1"
		}
		placement_configs {
			# availability_domain = "VrTN:EU-FRANKFURT-1-AD-2"
			availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[2].name
			subnet_id = "${oci_core_subnet.node_subnet.id}"
		}
		size = "2"
	}
	node_eviction_node_pool_settings {
		eviction_grace_duration = "PT60M"
	}
	node_shape = "VM.Standard.A1.Flex"
	node_shape_config {
		memory_in_gbs = "32"
		ocpus = "2"
	}
	node_source_details {
		image_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa3nbemlvqu3bxtkkgzqhflktc5ysjkq2o5nk7urs5tsywfeyzyacq"
		source_type = "IMAGE"
	}
}




# https://www.terraform.io/docs/providers/oci/d/containerengine_cluster_kube_config.html
data "oci_containerengine_cluster_kube_config" "cluster_kube_config" {	 
  cluster_id    = "${oci_containerengine_cluster.generated_oci_containerengine_cluster.id}"
  expiration    = 2592000
  token_version = "2.0.0"
}

# https://www.terraform.io/docs/providers/local/r/file.html
resource "local_file" "kubeconfig" {
  content  = "${data.oci_containerengine_cluster_kube_config.cluster_kube_config.content}"
  filename = "${path.module}/kubeconfig"
}


#kubectl --kubeconfig kubeconfig get nodes

#kubectl create -f https://k8s.io/examples/application/deployment.yaml
#kubectl expose deployment nginx-deployment --port=80 --target-port=80 --name=nginx-lb --type=LoadBalancer
#kubectl get service



# data "oci_containerengine_cluster_option" "test_cluster_option" {
#   cluster_option_id = "all"
# }

# data "oci_containerengine_node_pool_option" "test_node_pool_option" {
#   node_pool_option_id = "all"
# }

# data "oci_core_images" "shape_specific_images" {
#   #Required
#   compartment_id = var.tenancy_ocid
#   shape = "VM.Standard.A1.Flex"
# }




# resource "oci_containerengine_node_pool" "create_node_pool_details0" {
# 	cluster_id = "${oci_containerengine_cluster.generated_oci_containerengine_cluster.id}"
# 	compartment_id = var.compartment_ocid
# 	freeform_tags = {
# 		"OKEnodePoolName" = "pool1"
# 	}
# 	initial_node_labels {
# 		key = "name"
# 		value = "cluster2"
# 	}
# 	kubernetes_version = "v1.24.1"
# 	name = "pool1"
# 	node_config_details {
# 		freeform_tags = {
# 			"OKEnodePoolName" = "pool1"
# 		}
# 		placement_configs {
# 			availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0].name
# 			subnet_id = "${oci_core_subnet.node_subnet.id}"
# 		}
# 		size = "2"
# 	}
# 	node_eviction_node_pool_settings {
# 		eviction_grace_duration = "PT60M"
# 	}
# 	node_shape = "VM.Standard.A1.Flex"
# 	node_shape_config {
# 		memory_in_gbs = "32"
# 		ocpus = "2"
# 	}
# 	node_source_details {
# 		image_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa3nbemlvqu3bxtkkgzqhflktc5ysjkq2o5nk7urs5tsywfeyzyacq"
# 		source_type = "IMAGE"
# 	}
# }




# resource "oci_containerengine_node_pool" "create_node_pool_details0" {
# 	cluster_id = "${oci_containerengine_cluster.generated_oci_containerengine_cluster.id}"
# 	compartment_id = var.compartment_ocid
# 	freeform_tags = {
# 		"OKEnodePoolName" = "pool1"
# 	}
# 	initial_node_labels {
# 		key = "name"
# 		value = "A1Cluster"
# 	}
# 	kubernetes_version = "v1.24.1"
# 	name = "pool1"
# 	node_config_details {
# 		freeform_tags = {
# 			"OKEnodePoolName" = "pool1"
# 		}
# 		placement_configs {
# 			availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0].name
# 			subnet_id = "${oci_core_subnet.node_subnet.id}"
# 		}
# 		size = "2"
# 	}
# 	node_eviction_node_pool_settings {
# 		eviction_grace_duration = "PT60M"
# 	}
# 	node_shape = "VM.Standard.A1.Flex"
# 	node_shape_config {
# 		memory_in_gbs = "32"
# 		ocpus = "2"
# 	}
# 	node_source_details {
# 		# image_id = data.oci_core_images.images.images[0].id
# 		image_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa3nbemlvqu3bxtkkgzqhflktc5ysjkq2o5nk7urs5tsywfeyzyacq"
# 		source_type = "IMAGE"
# 	}

# 	# 	# optimized OKE images
# 	# dynamic "node_source_details" {
# 	# 	for_each = var.node_pool_image_type == "oke" ? [1] : []
# 	# 	content {
# 	# 	boot_volume_size_in_gbs = lookup(each.value, "boot_volume_size", 50)
# 	# 	# check for GPU,A1 and other shapes. In future, if some other shapes or images are added, we need to modify
# 	# 	image_id = (var.node_pool_image_type == "oke" && length(regexall("GPU|A1", lookup(each.value, "shape"))) == 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_pool_os_version}-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "oke" && length(regexall("GPU", lookup(each.value, "shape"))) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_pool_os_version}-Gen[0-9]-GPU-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)) : (var.node_pool_image_type == "oke" && length(regexall("A1", lookup(each.value, "shape"))) > 0) ? (element([for source in local.node_pool_image_ids : source.image_id if length(regexall("Oracle-Linux-${var.node_pool_os_version}-aarch64-20[0-9]*.*-OKE-${local.k8s_version_only}", source.source_name)) > 0], 0)) : null

# 	# 	source_type = data.oci_containerengine_node_pool_option.node_pool_options.sources[0].source_type
# 	# 	}
# 	# }



# }

# # Obtain cluster Kubeconfig.
# data "oci_containerengine_cluster_kube_config" "kube_config" {
#   cluster_id = oci_containerengine_cluster.generated_oci_containerengine_cluster.cluster_id
 
# }




# # Obtain cluster Kubeconfig.
# data "oci_containerengine_cluster_kube_config" "kube_config" {
#   cluster_id = module.oke_my_cluster.cluster_id
# }

# # Store kubeconfig in vault.
# resource "vault_generic_secret" "kube_config" {
#   path = "my/cluster/path/kubeconfig"
#   data_json = jsonencode({
#     "data" : data.oci_containerengine_cluster_kube_config.kube_config.content
#   })
# }

# # Store kubeconfig in file.
# resource "local_file" "kube_config" {
#   content         = data.oci_containerengine_cluster_kube_config.kube_config.content
#   filename        = "/tmp/kubeconfig"
#   file_permission = "0600"
# }




#https://github.com/oracle/terraform-provider-oci/blob/master/examples/container_engine/main.tf