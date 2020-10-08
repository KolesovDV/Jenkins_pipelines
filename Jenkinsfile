// Stage Create VM . Using terraform, ansible creates Digital Ocean Droplet, install packeges to work with php7.3. If failed - destroy droplet
// Stage Build Copy source code from SCM in  project dir, build content
// Stage Migrate Create postgres DB, fill it in
// Stage Test - running tests
// Stage Deploy replace projects symlink with new symlink, test https response
pipeline {
    agent { label 'master' }
    triggers { pollSCM('* * * * *') }
    
    environment {
        TAG_NAME               = sh(script: 'git tag --sort=committerdate | tail -1', , returnStdout: true).trim()
        do_token               = credentials('jenkins-do-token')
        aws_access_key         = credentials('jenkins-aws-access-key')
        aws_secret_key         = credentials('jenkins-aws-secret-key')
        postgres_passwd        = credentials('jenkins-postgres-passwd') //ansible use it to
        postgres_user          = credentials('jenkins-postgres-user')   //ansible use it to
        additional_ssh_key     = credentials('jenkins-additional-ssh-key')
        postgres_db            = 'symfony' //ansible use it to
        source_symlink_place   = '/usr/share/nginx/html'
        git_source_code        = 'git@gitlab.rebrainme.com:kolesov.dv/jenkins2.git'
        dnsrecord              = 'somerecord'
        aws_route53_zone       = "dns zone"
        php_source_build       = "https://github.com/symfony/demo.git"
        php_project_path       = "/opt"

    }
    stages {
       
        stage('Create VM') {
            agent { label 'master' }
            //when { tag "release-*" }
            steps {
                script {
                    sh "terraform version"
                     sh "terraform init && terraform apply  -var=\"postgres_passwd=${postgres_passwd}\"  -var=\"postgres_user=${postgres_user}\"   -var=\"postgres_db=${postgres_db}\"  -var=\"additional_ssh_key=${additional_ssh_key}\" -var=\"do_token=${do_token}\" -var=\"AWS_ACCESS_KEY_ID=${aws_access_key}\"  -var=\"AWS_SECRET_ACCESS_KEY=${aws_secret_key}\" --auto-approve"
                    sh "ssh root@${dnsrecord}.${aws_route53_zone}  'curl -sS https://getcomposer.org/installer -o composer-setup.php && php composer-setup.php --install-dir=/usr/local/bin --filename=composer ' "
               }
            }
             post {
                failure {
                    echo 'Allways'
                    sh "terraform destroy -var=\"do_token=${do_token}\" -var=\"AWS_ACCESS_KEY_ID=${aws_access_key}\"  -var=\"AWS_SECRET_ACCESS_KEY=${aws_secret_key}\" --auto-approve"
    }
        }
        }
        stage('Build') {
            //when { tag "release-*" }
            steps {
                echo 'Build..'
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'mkdir -p  ${php_project_path}/deploy && cd ${php_project_path}/deploy  && git clone ${php_source_build} ${env.BUILD_NUMBER}  '"
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ' cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && COMPOSER_MEMORY_LIMIT=-1 /usr/local/bin/composer install ' "
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ' cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && /usr/local/bin/composer update tgalopin/html-sanitizer && /usr/local/bin/composer update ' "
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ' cd ${php_project_path}/deploy/${env.BUILD_NUMBER} &&  /usr/local/bin/composer update erusev/parsedown && /usr/local/bin/composer update '"
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ' ln -s  ${php_project_path}/deploy/${env.BUILD_NUMBER} ${php_project_path}/demo ' " //link in not exist
            }
        }

        stage('Migrate') {
            //when { tag "release-*" }
            steps {
                echo 'Migrate..'
                sh "ssh root@${dnsrecord}.${aws_route53_zone} \"echo DATABASE_URL=\"postgresql://${postgres_user}:${postgres_passwd}@127.0.0.1:5432/${postgres_db}?serverVersion=10\" >> ${php_project_path}/demo/.env\" "
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ${php_project_path}/demo/bin/console doctrine:schema:create "
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ${php_project_path}/demo/bin/console doctrine:fixtures:load "
            }
        }
        
        stage('Test') {
            //when { tag "release-*" }
            steps {
              script {
                echo 'Testing..'
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && bin/phpunit '" 
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && bin/console lint:yaml config --parse-tags'" 
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && bin/console lint:twig templates --env=prod'" 
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && bin/console lint:xliff translations'" 
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && bin/console lint:container'" 
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && bin/console doctrine:schema:validate --skip-sync -vvv --no-interaction'" 
                sh "ssh root@${dnsrecord}.${aws_route53_zone} 'cd ${php_project_path}/deploy/${env.BUILD_NUMBER} && composer validate --strict'" 

            }
        }
    }
        stage('Deploy') {
            //when { changeset 'index.html' }
            steps {
              script {
                echo 'Deploying.. '
                def httpstatus=sh (returnStdout: true, script: "curl -s -o /dev/null -w \"%{http_code}\" https://\${dnsrecord}.\${aws_route53_zone} " ) 
                println(httpstatus)
                sh "ssh root@${dnsrecord}.${aws_route53_zone} ' mv ${php_project_path}/demo ${php_project_path}/previos_deploy && ln -s  --force ${php_project_path}/deploy/${env.BUILD_NUMBER} ${php_project_path}/demo ' "
                if (httpstatus.toInteger() != 200) {
                     echo 'ROLLBACK..';
                     sh "ssh root@${dnsrecord}.${aws_route53_zone} ' mv ${php_project_path}/previos_deploy ${php_project_path}/demo "
                 
                 }
            }
            }
        }
    }
    post {
    always {
          echo 'Allways'
    }
    success{
        echo 'Success'

    }
    failure {
        echo 'failure'

    }
    cleanup{
        deleteDir()
    }
}
}


