Create **Django APP** and place teh contents under *django_app* directory, in addition to the already existing files.<br>
Following this under `settings.py` change the *param* **HOST** value:
```python
DB_HOST = db #this is the name of the service for MYSQL from docker compose
DATABASES = {
    'default': {
        'HOST': DB_HOST
    }
    }
```