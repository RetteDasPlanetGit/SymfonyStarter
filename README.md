# Symfony Starter Project

This guide will walk you through the steps to deploy a Symfony app using Docker containers. Docker allows you to package your application and its dependencies into a container, providing a consistent and portable environment for deployment.

## Prerequisites

Before starting, ensure that you have the following prerequisites installed on your system:

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

Follow these steps to deploy your Symfony app:

1. Clone the repository:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Configure Symfony app:

    - Copy the `.env` file:

        ```bash
        cp .env.dist .env
        ```

    - Update the necessary environment variables in the `.env` file, such as `APP_ENV`, `DATABASE_URL`, etc.

3. Build and start Docker containers:

    ```bash
    docker-compose up -d --build
    ```

4. Install Symfony dependencies:

    ```bash
    docker-compose exec php composer install
    ```

5. Set up the database:

    ```bash
    docker-compose exec php bin/console doctrine:database:create
    docker-compose exec php bin/console doctrine:migrations:migrate
    ```

6. Access your Symfony app:

   Open your browser and navigate to `http://localhost` to access your Symfony app.

## Additional Configuration

- **Environment Variables**: Modify the `.env` file to configure your Symfony app's environment variables.
- **Docker Compose**: If you need to modify the Docker Compose configuration, update the `docker-compose.yml` file.
- **Production Deployment**: For production deployments, make sure to secure your containers and consider using a reverse proxy for SSL termination.

## Troubleshooting

- **Container Logs**: To view the logs of a specific container, use the following command:

    ```bash
    docker-compose logs -f <container-name>
    ```

- **Permissions**: If you encounter any permission issues, ensure that the necessary directories are writable by the container.

## Conclusion

You have successfully deployed your Symfony app using Docker containers. Feel free to customize the deployment process as per your project's specific requirements.

For more information on using Symfony with Docker, refer to the [Symfony Documentation](https://symfony.com/doc/current/setup/docker.html).

Happy coding!
