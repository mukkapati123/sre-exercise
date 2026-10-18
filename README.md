# sre-exercise

Repo for the SRE interview exercise.

## Overview

This repository contains Infrastructure as Code (IaC) for a multi-environment AWS deployment using Terraform, with CI/CD automation via GitHub Actions.

## Architecture

- **Foundation**: VPC with 2 public and 3 private subnets across multiple AZs for high availability
- **GitHub Actions IAM**: OIDC federation for secure, credential-free deployments
- **Least Privilege**: All IAM policies scoped by resource ARN and action

## Directory Structure
