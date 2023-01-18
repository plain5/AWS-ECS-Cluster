## DJANGO Environment Variables ##
Many Django settings necessary to run an app have been exposed as environment variables. Below 
is a list and what they do.

* *DEBUG* - set Django to debug mode. Defaults to `False` (set `True` if you need access to the `/admin` page).
* *DJANGO_ALLOWED_HOSTS* - the hostnames Django is allowed to receive requests from. This defaults to `127.0.0.1,localhost`. It can be a comma-delimited list. For more information about `allowed_hosts` view the [django documentation](https://docs.djangoproject.com/en/3.1/ref/settings/#allowed-hosts).
* *DEVELOPMENT_MODE* - this determines whether to use a Postgres DB or local sqlite. Defaults to `False` therefore using the Postgres DB.
* *DATABASE_URL* - The URL, including port, username, and password, to connect to a Postgres DB. It is required if *DEVELOPMENT_MODE* is `False`.
* *DJANGO_SECRET_KEY* - used to provide cryptographic signing. This key is used primarily to sign session cookies. If one were to have this key, one would be able to modify the cookies sent by the application.
* (Optional) In the active container on your clustered EC2 instance, run `python manage.py createsuperuser` and follow the prompts to create a super user to access at `/admin` (only if *DEBUG*=`True`).

## CircleCI `Project` Environment Variables ##
* *ACCOUNT_ID* - your AWS account ID.
* *AWS_ACCESS_KEY_ID* - access key of your IAM user.
* *AWS_SECRET_ACCESS_KEY* - secret access key of your IAM user.
* *CERTIFICATE_ARN* - ARN of the ACM SSL certificate.
* *ECR_URI* - Elastic Container Registry repository URI.
* *FOLDER* - the folder containing your remote `.tfstate` file in the S3 Bucket.
* *REGION* - the region's name in which to provision infrastructure.
* *REPO_NAME* - Elastic Container Registry repository name.
* *BUCKET* - S3 Bucket name for the remote `.tfstate` file.

## Important information ##
* Variables *DATABASE_URL* & *DJANGO_SECRET_KEY* are stored in the Parameter Store in the same region as the infrastructure is provisioned.
* *DATABASE_URL* has the following format : `postgres://YourUserName:YourPassword@YourHostname:5432/YourDatabaseName` (since I wasn't creating a real production project, I used an EC2 instance to host the Postgres database. Personally, I think you can better use AWS RDS for this purpose).
* `ecsTaskExecutionRole` for the task definition has the following policies : *AmazonECSTaskExecutionRolePolicy* and two `manually added` to enable access to the Parameter Store SecureString parameters. How to do it you can find out here : [AWS Systems Manager Parameter Store - Use Credentials with ECS Environment Variables (Hands-On)](https://www.youtube.com/watch?v=a6B9nF9nBiY).
* Don't forget to `Enable dynamic config using setup workflows` in the CircleCI project. For this, go to the *Project Settings* -> *Advanced* -> activate *Enable dynamic config using setup workflows*.
* Elastic Container Registry repository, *ecsTaskExecutionRole* and variables *DATABASE_URL* & *DJANGO_SECRET_KEY* are created manually (they are independent of Terraform!).
