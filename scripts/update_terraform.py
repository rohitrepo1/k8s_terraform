import sys
import json
import ast
import os
import shutil
import git

def main(clientname, region, nodecount, toolslist):
        directory = os.getcwd()
        print(directory)
        tools = toolslist.replace('[', ' ').replace(']', ' ').replace(',', ' ').split()
        tool = [i for i in tools]
        print len(tool)
       if len(tool) > 0:
          modified_list = "/".join(str(x) for x in tool)
        else:
          modified_list = ""
        command = 'ssh-keygen -f '+clientname+' -q -P ""'
        print (modified_list , clientname , region , nodecount)
        modified_dict = {}
        modified_dict = {'###SSH_KEY_NAME###': clientname, '###CLIENT###': clientname, '###IP_RANGE###': "11.1",
                         '###AWS_LOCATION###': region, '###NODE_COUNT###': nodecount,
                         '###TOOLS###': modified_list}

        fp1 = open(directory+"/k8s_terraform/modified.tf", "w")
        fp2 = open(directory+"/k8s_terraform/common_variables.tf", 'r')
        data = fp2.read()
        fp2.close()
        for key, value in modified_dict.items():
            data = data.replace(key, value)
        fp1.write(data)
        fp1.close()
        os.rename(directory+"/k8s_terraform/modified.tf", directory+"/k8s_terraform/common_variables.tf")
        os.chdir(directory+"/k8s_terraform/ssh_key")
        os.system(command)

if __name__ == "__main__":
    main(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4])
