//
//  SearchView.h
//  FFC
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface SearchView : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar1;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSString *serviceName;

@end
