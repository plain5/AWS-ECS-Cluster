package test

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/gruntwork-io/terratest/modules/terraform"
)



func TestMytest(t *testing.T) {
    t.Parallel()

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "/home/circleci/project/infrastructure",
	})

    ecs_cluster_name := terraform.Output(t, terraformOptions, "ecs_cluster_name")
    assert.Equal(t, "My-Cluster", ecs_cluster_name)

}