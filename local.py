from .common import *

MEDIA_URL = "https://TAIGA_HOST/media/"
STATIC_URL = "https://TAIGA_HOST/static/"
SITES["front"]["scheme"] = "https"
SITES["front"]["domain"] = "TAIGA_HOST"

SECRET_KEY = "CZfjWjHctPwnLZsDysWqaZcYfRCviHbI4fVRwfhpbtAHPNBtmkcegpwpYjTtEziJ"

DEBUG = TAIGA_DEBUG
PUBLIC_REGISTER_ENABLED = TAIGA_PUBLIC

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'taiga',
        'USER': 'taiga',
        'PASSWORD': 'DBPassword',
        'HOST': 'postgres',
        'PORT': '5432',
    }
}

MEDIA_ROOT = '/home/taiga/media'
STATIC_ROOT = '/home/taiga/static'

DEFAULT_FROM_EMAIL = "john@due.com"
#SERVER_EMAIL = DEFAULT_FROM_EMAIL

#CELERY_ENABLED = True
#CELERY_ALWAYS_EAGER = True

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": "amqp://taiga:StrongMQPassword@rabbit:5672/taiga"}

# Uncomment and populate with proper connection parameters
# for enable email sending. EMAIL_HOST_USER should end by @domain.tld
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
#EMAIL_USE_TLS = True
#EMAIL_USE_SSL = False
#EMAIL_HOST = ""
#EMAIL_HOST_USER = ""
#EMAIL_HOST_PASSWORD = ""
#EMAIL_PORT = 587

# Uncomment and populate with proper connection parameters