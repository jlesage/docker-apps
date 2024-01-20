---
layout: default
---

## Welcome!

This page lists Docker containers I've created to run some popular applications.

All these containers are based on [Alpine Linux](https://alpinelinux.org/), a
security-oriented, lightweight Linux distribution very popular to build Docker
containers.

Most implemented applications have a graphical user interface (GUI).  It can be
accessed through a modern web browser (no installation or configuration needed
on client side) or via any VNC client.  The built-in web UI is very nice and
mobile-friendly.

## Applications

<table>
  <tbody>
{% for item in site.data.apps %}
    <tr><td>
      <img style="vertical-align:middle" src="https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/{{ item.name }}-icon.png&amp;w=50" alt="{{ item.friendlyName }}"> <a href="https://github.com/jlesage/docker-{{ item.name }}#readme">{{ item.friendlyName }}</a>
    </td></tr>
{% endfor %}
  </tbody>
</table>

## Requests

Want a dockerized version of an application?  Add your suggestion by creating
an issue at [https://github.com/jlesage/docker-apps/issues](https://github.com/jlesage/docker-apps/issues).

## Support or Contact

Having trouble with one of the containers?  Use the application's link provided
in the table above to check out the documentation or to open an issue.
