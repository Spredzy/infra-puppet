# Custom Subject
define jira::custom_subject() {
  file {
  "/srv/jira/base/classes/templates/email/subject/${name}.vm":
    ensure => link,
    target => 'subject.vm'
    ;
  }
}
