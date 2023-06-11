# The Cloud Resume Challenge - AWS

In  order to present my skills in cloud infrastrucutre I will use this repo to reformat my reseume while undertaking the [ Cloud Resume Challange](https://cloudresumechallenge.dev/docs/the-challenge/aws/)

The challange lays out 16 steps:

1. Certification

    AWS Certified Solutions Architect - Associate (SAA)
    
    Embeded the digital Badge in the html to reflect.

2. HTML

    Took a boiler plate html from https://codepen.io/jewel998/pen/PgydGj

3. CSS

    CSS styling from https://codepen.io/jewel998/pen/PgydGj

4. Static Website

    Hosted the static site in an s3 bucket, configured in `terraform` one bucket public facing and the other with a private acl that holds the website assets

5. HTTPS

    The bucket(site) is hosted in AWS while CloudFlare provides the site DNS, SSL and CDN. CloudFlare also allows us to add page rules in the `terraform` configuration that can redirect  HTTP requests to HTTPS.

6. DNS
    
    CloudFlare

7. Javascript

    Created a function that fetches from two seprate API endpoints: *one that fetches the visitor count for the site and another API that connects to a Lambda that updates the table in DynamoDB to add another site visit.*

8. Database
    
    DynamoDB

9. API
    
    API Gateway
    
10. Python
    
    Used Python to build the Lambda functions in charge of counting site visitors.

11. Tests

12. Infrastructure as Code

    All the resources/configs are built in `terraform`

13. Source Control

    Hosted in github

14. CI/CD (Back end)

15. CI/CD (Front end)

16. Blog post
---