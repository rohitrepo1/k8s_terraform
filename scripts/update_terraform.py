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
        #strB = sys.argv[2].replace('[', ' ').replace(']', ' ').replace(',', ' ').split()
        tool = [i for i in tools]
        #print tool
        print len(tool)
        modified_list = " ".join(str(x) for x in tool)

        print (modified_list , clientname , region , nodecount)
        modified_dict = {}
        if modified_list == "" :
                modified_dict = {'###SSH_KEY_NAME###': clientname, '###CLIENT###': clientname, '###IP_RANGE###': "11.1",
                                 '###AWS_LOCATION###': region, '###NODE_COUNT###': nodecount,
                                 '###TOOLS###':  modified_list }
        else:

                modified_dict = {'###SSH_KEY_NAME###' : clientname,'###CLIENT###' : clientname,'###IP_RANGE###' : "11.1",'###AWS_LOCATION###' : region, '###NODE_COUNT###' : nodecount, '###TOOLS###' : "\"" + modified_list + "\""}

        #git.Git(directory).clone("https://github.com/projectethan007/k8s_terraform.git")
        fp1 = open(directory+"/k8s_terraform/modified.tf", "w")
        fp2 = open(directory+"/k8s_terraform/common_variables.tf", 'r')
        data = fp2.read()
        fp2.close()
        for key, value in modified_dict.items():
            data = data.replace(key, value)
        fp1.write(data)
        fp1.close()
        os.rename(directory+"/k8s_terraform/modified.tf", directory+"/k8s_terraform/common_variables.tf")

if __name__ == "__main__":
    main(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4])
