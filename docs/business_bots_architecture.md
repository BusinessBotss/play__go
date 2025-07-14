# Business Bots Architecture

This document outlines a recommended architecture for the Business Bots platform.
It summarizes the services and tooling needed to support AI-driven automation for
multiple industries.

## Repository Structure
- **Monorepo**: Use a monorepo (e.g. Lerna or TurboRepo) to manage multiple
  services. Shared configurations and tooling live in one place.
- **Service-specific Repositories**: If certain services must be deployed
  independently, keep them in separate repositories and integrate using a common
  CI/CD pipeline or git submodules.

## Initial Services
- **Auth Service**: Provides OAuth2-compatible authentication and user
  management with support for admin, client and integration roles.
- **API Gateway**: Routes incoming requests to backend services (Auth, Bookings,
  Events, etc.), handles request logging and rate limiting.
- **Bots, Bookings, Events**: Separate services for core business logic. Each
  can evolve independently and scale based on demand.

## Infrastructure with Helm
- Create a Helm chart for each service including Deployment, Service and
  Ingress resources.
- Store configuration in ConfigMaps and sensitive data in Kubernetes Secrets.
- Keep templates consistent so new services follow the same conventions.

## Development Cluster Deployment
1. Start a local Kubernetes cluster with `kind` or `minikube`.
2. Deploy the Auth, Bookings, Events and API Gateway services using Helm.
3. Test authentication flows:
   - Register a user and obtain a token.
   - Send requests to Bookings and Events via the API Gateway using the token.

## CI/CD
- Use GitHub Actions or a similar tool to lint, test and build Docker images.
- Package Helm charts and deploy automatically to the development cluster.
- Manage secrets within the CI tool for safe access to tokens and credentials.

## Observability
- **Logging**: Aggregate logs with Elasticsearch/Fluentd/Kibana (EFK) or a
  managed logging service.
- **Metrics**: Collect Prometheus metrics and visualize with Grafana.
- **Monitoring**: Configure alerts on service failures, latency spikes and high
  error rates.

## Migration Strategy
- **Monolith Extraction**: Gradually extract components (e.g. Auth) from any
  existing monolith to new microservices.
- **Gradual Replacement**: Route traffic through the API Gateway to the new
  services as they become stable.
- **MVP Launch**: Release once essential workflows are functional.

## Ongoing Improvements
- Automate deployments to staging and production after the dev environment is
  stable.
- Use Infrastructure as Code (Terraform or Pulumi) for cluster setup.
- Expand logging and monitoring as new services are added.
- Document best practices for integration with external platforms like Zapier or
  N8n.

