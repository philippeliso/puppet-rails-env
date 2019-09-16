class deb_essentials {

	include deb_essentials::deb_deploy
	include deb_essentials::deb_cron
	include deb_essentials::deb_terraform
	include deb_essentials::deb_azure_cli
	include deb_essentials::deb_kubectl

}

