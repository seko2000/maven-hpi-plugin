#!/bin/bash -ex
# copy hpi-archetypes as resources, by performing necessary transformations for an archetype.
dst=target/classes/archetype-resources
rm -rf $dst
cp -R hpi-archetype $dst
rm -rf $(find $dst -name .svn) $dst/target $dst/hpi-archetype.*

# inject the package statement
for f in $(find $dst -name '*.java')
do
  mv $f $f.tmp
  echo 'package ${groupId};' > $f
  cat $f.tmp >> $f
  rm $f.tmp
done

# modify POM
perl -pi -e 's|<!-- \$ --><([^>]+)>.+<!-- /\$ -->|<$1>\$\{$1\}</$1>|g' $dst/pom.xml

perl -pi -e 's|hpi-archetype|\@artifactId\@|g' $(find $dst -type f)