#include "unity_fixture.h"

TEST_GROUP(template);

TEST_SETUP(template)
{
   /* Init before every test */
}

TEST_TEAR_DOWN(template)
{
   /* Cleanup after every test */
}

TEST(template, first)
{
   TEST_FAIL_MESSAGE("initial test setup");
}
