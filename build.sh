#! /usr/bin/env sh
echo "Building CGRateS ..."

GIT_LAST_LOG=$(git log -1 | tr -d "'")

go install -mod=vendor -ldflags "-X 'github.com/cgrates/cgrates/utils.GitLastLog=$GIT_LAST_LOG'" github.com/cgrates/cgrates/cmd/cgr-engine
cr=$?
go install -mod=vendor -ldflags "-X 'github.com/cgrates/cgrates/utils.GitLastLog=$GIT_LAST_LOG'" github.com/cgrates/cgrates/cmd/cgr-loader
cl=$?
go install -mod=vendor -ldflags "-X 'github.com/cgrates/cgrates/utils.GitLastLog=$GIT_LAST_LOG'" github.com/cgrates/cgrates/cmd/cgr-console
cc=$?
go install -mod=vendor -ldflags "-X 'github.com/cgrates/cgrates/utils.GitLastLog=$GIT_LAST_LOG'" github.com/cgrates/cgrates/cmd/cgr-migrator
cm=$?
go install -mod=vendor -ldflags "-X 'github.com/cgrates/cgrates/utils.GitLastLog=$GIT_LAST_LOG'" github.com/cgrates/cgrates/cmd/cgr-tester
ct=$?

exit $cr || $cl || $cc || $cm || $ct
