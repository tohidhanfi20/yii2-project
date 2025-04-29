FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl

# Install PHP extensions required by Yii2
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy composer files first for better Docker cache
COPY src/composer.json src/composer.lock ./

# Allow the Yii2 Composer plugin
RUN composer config --no-plugins allow-plugins.yiisoft/yii2-composer true

# Install dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copy the rest of the Yii2 app
COPY src/ /var/www/html/

# Set permissions (adjust as needed for your environment)
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000
CMD ["php-fpm"]