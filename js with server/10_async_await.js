// 10_async_await.js

async function getPostInfo() {
    let postList = await fetch('https://jsonplaceholder.typicode.com/posts')
                        .then(res => res.json())
                        .catch(err => console.log(err));

    let postId = postList[0].id;
    let post = await fetch(`https://jsonplaceholder.typicode.com/posts/${postId}`)
                    .then(res => res.json())
                    .catch(err => console.log(err));

    
    let commentList = await fetch(`https://jsonplaceholder.typicode.com/posts/${postId}/comments`)
                            .then(res => res.json())
                            .catch(err => console.log(err));

    post.comments = commentList;
    console.log(post);
}

getPostInfo();
console.log('코드 종료');
// 함수 내부는 동기 작업이지만 전체는 비동기작업 -> 코드 종료가 먼저 출력됨
