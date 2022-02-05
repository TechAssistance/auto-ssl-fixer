import shutil
import subprocess
import socket
import json
import dns.resolver
import pandas as pd
from IPython.display import display


# define method for getting all registered public ipaddresses
def getpublicip():
    """
        Query the whm api (v1) and pull the ips from the response as these are the ips autossl uses for dcv
            :params:
                None           -
            :return:
                gatheredIPs       -   Type : List public ips on server (List)
    """
    # declare empty boi
    gatheredIPs = []
    # get that good data using a subprocess and make it into a dict
    processBoi = subprocess.Popen(['whmapi1', '--output=jsonpretty', 'listips'], stdout=subprocess.PIPE)
    responseInfo = processBoi.stdout.read().decode("utf-8")
    responseData = json.loads(responseInfo)
    # loop through all that good stuff to make a list of ips
    for ipaddrs in responseData['data']['ip']:
        gatheredIPs.append(ipaddrs['public_ip'])
    return gatheredIPs


# define method for determining if domain names resolve to a public ip on the box
def check_doesitresolve(domain):
    """
        check if provided domain resolves to a ip on the server
            :params:
                domain   -   Required : domain(str)
            :return:
                answer   -   Bool : True if resolves, false it not or if no resolution at all
    """
    # set up resolver
    resolver = dns.resolver.Resolver()
    # create return value, assume no
    answer = False
    # do the queries and grab the records as data
    try:
        Arec = resolver.query(domain, 'A')
        for i in Arec.response.answer:
            for j in i.items:
                domainIP = j.to_text()
        if domainIP in ips:
            answer = True
        return answer
    except Exception as e:
        # implement some logging here at some point
        return answer


def getuserdomains():
    """
        Call a loop that will go through the /etc/userdomains file on the server and return a list
            :params:
                None           -
            :return:
                fileData       -   Type : List of domains and theis assigned users
    """
    fileData = [line.split(': ', 1) for line in open('/etc/userdomains')]
    del fileData[0]
    # remove newline from the list
    for i in range(len(fileData)):
        fileData[i][1] = fileData[i][1].replace('\n', '')
    return fileData


def constdictboi(userdomlist, subdomlist):
    """
        Call a loop that will work through a user domain list to construct a dict list and determine if domains resolve
        :params:
            userdomlist    -   Required : user domain list in l = [['domain','user'],] format (List)
            sublist        -   Required : subdomain list (List)
        :return:
            tempDict       -   Type : List of dict
    """
    tempDict = [dict() for number in range(len(userdomlist))]
    l = len(subdomlist)
    print('Checking DCV ...')
    printProgressBar(0, l, prefix='Progress:', suffix='Complete', autosize=True)
    for i in range(len(userdomlist)):
        currentdomain = str((userdomlist[i][0]))
        # check if the root domains resolve and store that value in a key:bool
        if check_doesitresolve(currentdomain):
            tempDict[i]['Root Resolves'] = True
        else:
            tempDict[i]['Root Resolves'] = False
        # get the account name from the account list and add it to a key:str
        tempDict[i]['Account'] = userdomlist[i][1]
        tempDict[i]['Domain name'] = currentdomain
        for j in range(len(subdomlist)):
            printProgressBar(j + 1, l, prefix='Progress on ' + currentdomain + ':', suffix='Complete', autosize=True)
            selectedsub = str(subdomlist[j])
            if check_doesitresolve(selectedsub + currentdomain):
                tempDict[i][selectedsub] = True
            else:
                tempDict[i][selectedsub] = False
    return tempDict


def removefromautossl(dictlist):
    """
        Call a loop that iterates through a dict list and queries local whmapi (v1) add_autossl_user_excluded_domains ep
        :params:
            dictlist    -   Required : dict list that will be processed (List)
    """
    print('Beginning Auto SSl clean up...')
    l = len(sublist)
    printProgressBar(0, l, prefix='Progress:', suffix='Removed from auto SSL', autosize=True)
    for i in range(len(dictlist)):
        account = str(dictlist[i]['Account'])
        domain = dictlist[i]['Domain name']
        if not (dictlist[i]['Root Resolves']):
            # we save the commands as a streng due to how strings get jacked up when ref in a sub process
            rootyeetcommand = "whmapi1 --output=jsonpretty add_autossl_user_excluded_domains username='{}' domain='{}'".format(
                account, domain)
            out = subprocess.getstatusoutput([rootyeetcommand, ])
            # some logging here if I feel like it
        for j in range(len(sublist)):
            printProgressBar(j + 1, l, prefix='Progress on ' + domain + ':', suffix='Removed from auto SSL', autosize=True)
            selectedsub = str(sublist[j])
            if not (dictlist[i][selectedsub]):
                subyeetcommand = "whmapi1 --output=jsonpretty add_autossl_user_excluded_domains username='{}' domain='{}{}'".format(
                    account, selectedsub, domain)
                out = subprocess.getstatusoutput([subyeetcommand, ])


def runautossl():
    """
    Triggers auto ssl to run on all cpanel accounts
    :params:
        none
    :return:
        none
    """
    runcommand = "whmapi1 --output=jsonpretty start_autossl_check_for_all_users"
    response = subprocess.getstatusoutput([runcommand],)
    print('[*] Auto SSL for all accounts has been started')

def printProgressBar(iteration, total, prefix='', suffix='', decimals=1, length=100, fill='█', autosize=False):
    """
       Call in a loop to create terminal progress bar
       :params:
           iteration   - Required  : current iteration (Int)
           total       - Required  : total iterations (Int)
           prefix      - Optional  : prefix string (Str)
           suffix      - Optional  : suffix string (Str)
           decimals    - Optional  : positive number of decimals in percent complete (Int)
           length      - Optional  : character length of bar (Int)
           fill        - Optional  : bar fill character (Str)
           autosize    - Optional  : automatically resize the length of the progress bar to the terminal window (Bool)
   """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    styling = '%s |%s| %s%% %s' % (prefix, fill, percent, suffix)
    if autosize:
        cols, _ = shutil.get_terminal_size(fallback=(length, 1))
        length = cols - len(styling)
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print('\r%s' % styling.replace(fill, bar), end='\r')
    # Print New Line on Complete
    if iteration == total:
        print()


# make script go brr
if __name__ == '__main__':
    # get the server info
    hostname = socket.gethostname()
    ips = getpublicip()
    userdomainlist = getuserdomains()
    sublist = ['mail.', 'cpcontacts.', 'www.', 'webmail.', 'webdisk.', 'cpanel.', 'whm.', 'cpcalendar.']
    dataset = constdictboi(userdomainlist, sublist)
    dataframe = pd.json_normalize(dataset, meta=['Domain name', 'Root Resolves', 'Account', sublist])
    # print(tabulate(dataframe, headers = 'keys', tablefmt = 'rst'))
    print('\n')
    userinput = input('Would you like to display DCV report? Options: y/n \n')
    if userinput == 'y':
        print('Displaying DCV results report:')
        display(dataframe)
    userinput = input('Would you like to remove failed domains from auto ssl? Options: y/n \n')
    if userinput == 'y':
        removefromautossl(dataset)
    userinput = input('Would you like to run auto ssl for all accounts? Options: y/n \n')
    if userinput == 'y':
        runautossl()
        print('Complete')
    else:
        print('Complete')

