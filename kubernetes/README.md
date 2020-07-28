# Kubernetes (k8s)

This documentation seeks to expound upon some key elements of kubernetes as well as provide a rationale for the
structure of this directory.

## Kustomize

As mentioned in the root README,
[Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) is a standalone tool that
allows you to customize Kubernetes configurations.
One motivation behind Kustomize is to make resource configuration code reusable across deployments,
or different projects. 

### Bases

**Bases** are essentially directories (local or remote) that have a `kustomization.yaml` file containing a set of
resources and customizations.

### Overlays

**Overlays** are similar to **Bases**,
as they are also directories (local or remote) that have a `kustomization.yaml` file,
but it instead refers to other kustomization directories as its `bases`.
