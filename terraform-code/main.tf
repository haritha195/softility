provider "google" {
    project     = "molten-medley-415817"
    credentials = "${file("credentials.json")}"
    region = "us-west4"
    zone = "us-west4-b"

}

resource "google_compute_instance" "jenkins" {
    name = "jenkins"
    machine_type = "n1-standard-4"
    zone = "us-west4-b"
    allow_stopping_for_update = "true"
    
    boot_disk {
        initialize_params{
            image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240229"
        }    
    }

     network_interface {
    #     network    = "google_compute_network.jenkins_network.self_link"
    #     subnetwork = "google_compute_subnetwork.jenkins_subnet.slef_link"
          access_config{
          network_tier = "PREMIUM"
        }
    }
}

resource "google_compute_network" "jenkins_network" {
    name = "jenkins-network"
    auto_create_subnetworks = "false"

}

# resource "google_compute_subnetwork" "jenkins_subnet" {
#     name = "jenkins-subnetwork"
#     ip_cidr_range = "10.20.0.0/16"
#     region = "us-west4"
#     network = "google_compute_network.jenkins_network.id"
# }

