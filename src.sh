set -e

# Utility repeat function to display char N times
repeat(){
	local start=1
	local end=${1:-80}
	local str=${2:-=}
    for ((i=start; i<=end; i++))
    do
        echo -n "${str}"
    done
}

while getopts v:d: flag;
do
    case "${flag}" in
        (v) PYTHON_VERSION=${OPTARG};;
        (d) DIRECTORY_PATH=${OPTARG};;
    esac
done

if [[ $PYTHON_VERSION == "" ]]; then
    echo "Please provide the python version"
    exit 1
elif [[ $DIRECTORY_PATH == "" ]]; then
    echo "Please provide the directory path to install python"
    exit 1
fi

# Logging the provided input values
repeat; echo
echo "Input details"
repeat 80 "~"; echo
echo "Python version: $PYTHON_VERSION";
echo "Directory Path: $DIRECTORY_PATH";
repeat; echo; echo

# sudo apt-get install build-essential checkinstall
# sudo apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
sudo apt-get update
sudo apt-get install gdebi-core

cd $DIRECTORY_PATH
CHECK_VERSION="$(echo $PYTHON_VERSION | cut -d'.' -f1-2)"
sudo wget "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz"
sudo tar -xzf "Python-$PYTHON_VERSION.tgz"
cd Python-$PYTHON_VERSION
sudo ./configure --enable-optimizations
sudo make altinstall
python$PYTHON_VERSION
if [[ $? -ne 0 ]]; then
    echo "Some error occurred while installing python version - $PYTHON_VERSION"
else
    echo "Successfully installed python version $PYTHON_VERSION at $(which python$PYTHON_VERSION)"
fi
