# Symfony Starter Project

There are two ways to install and deploy this Project:

### 1. Execute the following command:
```bash
curl -fsSL https://raw.githubusercontent.com/RetteDasPlanetGit/SymfonyStarter/main/scripts/install.sh | bash 
```
### 2. Follow the following steps to install step by step:

## Prerequisites

Before starting, ensure that you have the following prerequisites installed on your system:

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

### Install Docker
```shell
curl -fsSL https://get.docker.com -o get-docker.sh &&
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
```

### Install Docker Compose (Plugin)
```shell
sudo apt-get install docker-compose-plugin -y
```

### Install Docker Compose (Standalone)
```shell
sudo apt-get install docker-compose -y
```

## Components

The Symfony app uses the following components:

```text
- PHP: >= 8.1
- doctrine/annotations
- doctrine/doctrine-bundle
- doctrine/doctrine-migrations-bundle
- doctrine/orm
- ramsey/uuid
- symfony/asset
- symfony/console
- symfony/dotenv
- symfony/expression-language
- symfony/flex
- symfony/form
- symfony/framework-bundle
- symfony/http-client
- symfony/mime
- symfony/property-access
- symfony/property-info
- symfony/runtime
- symfony/security-bundle
- symfony/serializer
- symfony/twig-bundle
- symfony/validator
- symfony/yaml
```
The development environment also includes the following components:
```text
- symfony/maker-bundle
- symfony/stopwatch
- symfony/web-profiler-bundle
- twig/extra-bundle
- twig/twig
```
The development environment also includes the following components:
```text
- symfony/maker-bundle
- symfony/stopwatch
- symfony/web-profiler-bundle
- twig/extra-bundle
- twig/twig
```

## Getting Started

Follow these steps to deploy your Symfony app:

1. Clone the repository:

    ```bash
    git clone https://github.com/RetteDasPlanetGit/SymfonyStarter.git
    cd SymfonyStarter
    ```

2. Configure Symfony app:

   - Generate a new `APP_SECRET`:

       ```bash
       APP_SECRET=$(openssl rand -hex 32)
       sed -i "s|^APP_SECRET=.*$|APP_SECRET=$APP_SECRET|" .env
       ```

    - Update the necessary environment variables in the `.env` file, such as `APP_ENV`, `DATABASE_URL`, etc.

3. Build and start Docker containers:

    ```bash
    sudo docker compose build --build-arg APP_UID="$(id -u)" --build-arg APP_GID="$(id -g)" &&
    sudo docker compose up -d 
    ```

4. Install Symfony dependencies:

    ```bash
    sudo docker compose exec app composer install
    ```

5. Set up the database:

    ```bash
    sudo docker compose exec app bin/console doctrine:database:create
    sudo docker compose exec app bin/console doctrine:migrations:migrate
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
    sudo docker-compose logs -f app
    ```

- **Permissions**: If you encounter any permission issues, ensure that the necessary directories are writable by the container.

## Conclusion

You have successfully deployed your Symfony app using Docker containers. Feel free to customize the deployment process as per your project's specific requirements.

For more information on using Symfony with Docker, refer to the [Symfony Documentation](https://symfony.com/doc/current/setup/docker.html).

Happy coding!
