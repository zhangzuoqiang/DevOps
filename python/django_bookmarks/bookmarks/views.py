from django.http import HttpResponse,Http404
from django.template import Context
from django.template.loader import get_template
from django.contrib.auth.models import User
from django.shortcuts import render_to_response
from django.contrib.auth import logout
from django.http import HttpResponseRedirect

def main_page(request):
    context = {
        'head_title':'Django Bookmarks',
        'page_title':'Welcome to Django Bookmarks',
        'page_body':'Where you can store and share bookmarks!',
        'user':request.user,
        }

    return render_to_response('main_page.html',context)


def user_page(request,username):
    try:
        user = User.objects.get(username=username)
    except:
        raise Http404('Requested user not found.')
    bookmarks = user.bookmark_set.all()

    template = get_template('user_page.html')
    context = Context({
        'username':username,
        'bookmarks':bookmarks,
        })
    output = template.render(context)
    return HttpResponse(output)

def logout_page(request):
    logout(request)
    return HttpResponseRedirect('/')    
