python3 -m venv ~/.capstone
source ~/.capstone/bin/activate
pip install --upgrade pip &&\
  pip install -r requirements.txt

pylint app/app.py