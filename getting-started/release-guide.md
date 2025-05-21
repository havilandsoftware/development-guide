# Release Guide

This guide outlines the standard process for releasing applications to development and production environments.

## Release Process Overview

1. Close PRs and Tickets
2. Tag Applications
3. Snapshot Database
4. Deploy to Development Environment
5. Test in Development
6. Deploy to Production Environment
7. Verify Production Deployment

## Detailed Steps

### 1. Close PRs and Tickets

- Ensure all pull requests related to the release are reviewed and merged
- Update and close all associated tickets in Jira/Trello
- Conduct a final review of the release notes

### 2. Tag Applications
Use the [github-ops](https://github.com/havilandsoftware/github-ops) repository to tag applications `python src/main.py release -t <tag> -c <topic>`

### 3. Snapshot Database

- Create a backup of the production database before deployment
- Store the backup in a secure location with appropriate access controls
- Verify the backup is complete and accessible

### 4. Deploy to Development Environment

- Use the CI/CD pipeline to deploy the tagged version to the development environment
- Monitor the deployment process for any errors or warnings
- Verify all services are running correctly after deployment

### 5. Test in Development

- Conduct thorough testing in the development environment
- Verify all new features work as expected
- Check for any regressions in existing functionality
- Perform load testing if applicable
- Validate integrations with external systems

### 6. Deploy to Production Environment

- Schedule the production deployment during a low-traffic period
- Notify stakeholders about the upcoming deployment
- Use the CI/CD pipeline to deploy the tagged version to production
- Monitor the deployment process closely
- Follow the deployment checklist for your specific application

### 7. Verify Production Deployment

- Verify all services are running correctly in production
- Conduct smoke tests to ensure critical functionality works
- Monitor application performance and error rates
- Check logs for any unexpected errors or warnings
- Notify stakeholders that the deployment is complete

## Post-Release Activities

- Monitor the application for 24-48 hours after deployment
- Address any issues that arise promptly
- Document any lessons learned during the release process
- Schedule a retrospective meeting to discuss improvements for future releases
- Update documentation if necessary



