# Stage 1: Builder
FROM composer:2 as builder

# Set working directory
WORKDIR /app

# Clone the Laravel repository
RUN git clone https://github.com/baradhili/resource_mgr.git .

# Install Composer dependencies
RUN composer install --no-dev --no-scripts --optimize-autoloader

# Stage 2: Application
FROM php:8.2-fpm

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Copy the application code from the builder stage
COPY --from=builder /app /var/www/html

# Copy the custom PHP configuration
COPY php.ini /usr/local/etc/php/php.ini

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]