CFLAGS = -Wall -g -O0

EXECS =  hello hello_wait remote_filecheck one_socket two_socket one_print

all : $(EXECS)

clean:
	rm -f $(EXECS)
	rm -f ./message_one/libmessage.so ./message_two/libmessage.so

hello : hello.c
	cc $(CFLAGS) $^ -o $@

hello_wait : hello_wait.c
	cc $(CFLAGS) $^ -o $@

remote_filecheck : remote_filecheck.c
	cc $(CFLAGS) $^ -o $@

one_socket : one_socket.c message_one/libmessage.so
	cc $(CFLAGS) $< -o $@ -I./message_one -L./message_one -lmessage -Wl,-rpath,${PWD}/message_one

two_socket : two_socket.c message_two/libmessage.so
	cc $(CFLAGS) $< -o $@ -I./message_one -L./message_two -lmessage -Wl,-rpath,${PWD}/message_two

one_print : one_print.c message_one/libmessage.so
	cc $(CFLAGS) $< -o $@ -I./message_one -L./message_one -lmessage -Wl,-rpath,${PWD}/message_one

message_one/libmessage.so: message_one/message.c
	gcc -fPIC -shared $^ -o $@

message_two/libmessage.so: message_two/message.c
	gcc -fPIC -shared $^ -o $@

