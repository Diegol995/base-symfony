# Imagen base oficial de PHP con Apache
FROM php:8.2-apache

# Instala extensiones y utilidades necesarias para Symfony
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip

# Habilitar mod_rewrite (necesario para Symfony)
RUN a2enmod rewrite

# Instalar Composer globalmente
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Configuración básica de Apache para permitir el uso de .htaccess
RUN echo "<Directory /var/www/html>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" > /etc/apache2/conf-available/symfony.conf \
    && a2enconf symfony

RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Puerto expuesto
EXPOSE 80
