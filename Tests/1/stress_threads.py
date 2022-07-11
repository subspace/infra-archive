#!/usr/bin/env python3
# -*- coding: utf-8 -*-
s

#import queue
#from urllib.request import urlopen
import threading
from substrateinterface import SubstrateInterface
from substrateinterface.exceptions import SubstrateRequestException
import json
import time
from datetime import datetime


#with open("/app/runtime_types.json") as f:
#    d = json.load(f)
    #print(d)

def worker1():
   
   substrate = SubstrateInterface(
   url="ws://5.161.47.254:9844",
   ss58_format=42)
   
   

   
     
   while True:
        try:
            head_chain = substrate.get_chain_head()
            time.sleep(6)
            print(head_chain)
            print(datetime.now())
           
           # print(i.name)

        except ConnectionRefusedError:
            print("error in block retrival")
            exit()

def main():
    worker1()


if __name__ =="__main__":
    main()
