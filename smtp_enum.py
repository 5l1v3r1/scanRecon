import socket,sys

def recv_till_crtl(s):
      data = ""
      #time_out = 10
      while "\x0d\x0a" not in data:
            #print 'data:',data
            data+=s.recv(1)


      return data

print "INFO: Trying SMTP Enum on " + sys.argv[1] +":"+ sys.argv[2]
port = int(sys.argv[2])
names = open('users-offsec', 'r').read()
file = open("nmap-results/%s/smtp/user_enum"%(sys.argv[1]),'w')
for name in names:
    s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    connect=s.connect((sys.argv[1],port))
    banner=recv_till_crtl(s)
    print banner
    s.send('HELO test.org \r\n')
    result= recv_till_crtl(s)
    print result
    s.send('VRFY ' + name.strip() + '\r\n')
    result=recv_till_crtl(s)
    if ("not implemented" in result) or ("disallowed" in result):
      sys.exit("INFO: VRFY Command not implemented on " + sys.argv[1]) 
    if (("250" in result) or ("252" in result) and ("Cannot VRFY" not in result)):
      print "[*] SMTP VRFY Account found on " + sys.argv[1] + ": " + name.strip()
      f.write("[*] SMTP VRFY Account found on " + sys.argv[1] + ": " + name.strip()+"\n") 
    s.close()
