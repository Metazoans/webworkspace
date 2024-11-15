let post = null;

fetch('https://jsonplaceholder.typicode.com/posts')
.then(res => res.json())
.then(postList =>{
  let postId = postList[0].userId;
  fetch(`https://jsonplaceholder.typicode.com/posts/${postId}`)
  .then(res => res.json())
  .then(postInfo => {
    post = postInfo;
    fetch(`https://jsonplaceholder.typicode.com/posts/${postId}/comments`)
    .then(res => res.json())
    .then(commentList => {
      post.comments = commentList;
      console.log(post);
    })
    .catch(err => console.log(err));
  })
  .catch(err => console.log(err));
})
.catch(err => console.log(err));

