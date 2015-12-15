import sys
import os
import mediagoblin
from mediagoblin.app import MediaGoblinApp
from mediagoblin import mg_globals

mg_dir = os.getcwd()
config_file = mg_dir + "/mediagoblin_local.ini"
mg_app = MediaGoblinApp(config_file, setup_celery=True)

from mediagoblin.init.celery import setup_celery_app
setup_celery_app(mg_globals.app_config, mg_globals.global_config,
	     force_celery_always_eager=True)

from mediagoblin.plugins.gmg_localfiles.import_files \
import ImportCommand
base_dir = mg_globals.global_config['storage:publicstore']['base_dir']
ImportCommand(mg_app.db, base_dir).handle(sys.argv[1])
