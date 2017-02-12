# ASDKParrentChangingIssueSample

Sample project for AsyncDisplayKit issue presenting

ASDK v2.1 (also tested on 2.0, 2.0.1, 2.0.2)

Should be tested on iPhone.

Case: Trying to show different layout in portrait and landscape. In landscape image placed on root node, but in portrait it placed on proxy node that placed on root node.

Ascii pic for better understanding:
Portrait:

```
 ----ASStackLayoutSpec-----
|   ---ASDisplayNode---    |
|  |   ASImageNode     |   |
|  |    ASTextNode     |   |
|   --------------------   |
---------------------------
```

Landscape:

```
-------------ASStackLayoutSpec-----------
|                ---ASDisplayNode---    |
| ASImageNode   |   ASTextNode      |   |
|                -------------------    |
-----------------------------------------
```

Q: Why you use that proxy node? It has no sense there.

A: The real case was that proxy node was ASScrollNode or ASTableNode. So in portrait all content was scrollable but in landscape only text was scrollable, image had fixed position. In ascii pic and sample project I use simple ASDisplayNode for more clarity.

After that case was implemented I see such a problem - image node visible only in portrait. I suspect it is because of parent changing while layout, but I could be wrong.
