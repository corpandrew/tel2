import glob, os

directory = '/Users/corpa/Downloads/images.techxlab.org-gh-pages/ast/'

for file in os.listdir(os.path.abspath(directory)):
    if(file.endswith(".png") or file.endswith(".jpg") or file.endswith(".jpeg" or file.endswith(".gif"))):
        print('  - images/' + file)
    else:
        os.remove(os.path.join(directory, file))